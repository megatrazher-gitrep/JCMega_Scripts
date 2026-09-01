/*
================================================================================
  @description  JCMega Render Segments
  @version      1.0.0
  @author       JC MediaFX / MegaTrazher
  @target       aftereffects
  @about
      Herramienta de render por segmentos para After Effects.

      Divide el render de una composicion en N segmentos por rango de
      fotogramas y los renderiza:

        - En cola de AE (secuencial, sin dependencias externas), o
        - En paralelo lanzando varias instancias de "aerender" en segundo
          plano (aprovecha todos los nucleos de la CPU), y luego
        - Une (opcional) los segmentos con ffmpeg mediante el demuxer concat.

      Inspirada en el flujo de "Render Segments" de aescripts. Pensada para
      acelerar renders largos en equipos multinucleo y para poder reanudar
      solo los segmentos que fallen.

  @changelog
      1.0.0 - Version inicial.

  @usage
      1. File > Scripts > Run Script File...  (o dejar el .jsx en la carpeta
         "ScriptUI Panels" para tenerlo como panel acoplable).
      2. Seleccionar/activar la composicion a renderizar.
      3. Elegir numero de segmentos, plantillas, archivo de salida y modo.
      4. "Anadir a la cola" (secuencial) o "Renderizar en paralelo".

  @notes
      - Requiere After Effects CC (ExtendScript). Probado con CS6+.
      - El render en paralelo requiere una version de AE con "aerender".
      - La union de video (.mov/.mp4) requiere ffmpeg en el sistema.
      - Las secuencias de imagenes (PNG/EXR/etc.) no necesitan union: cada
        instancia escribe en la misma carpeta con numeracion continua.
================================================================================
*/

(function (thisObj) {
    "use strict";

    // -------------------------------------------------------------------------
    // Metadatos y constantes
    // -------------------------------------------------------------------------
    var APP = {
        name: "JCMega Render Segments",
        shortName: "Render Segments",
        version: "1.0.0",
        settingsSection: "JCMega_RenderSegments"
    };

    var MODE_QUEUE = "queue";       // Render secuencial en la cola de AE
    var MODE_PARALLEL = "parallel"; // Render paralelo con aerender

    // -------------------------------------------------------------------------
    // Utilidades de plataforma
    // -------------------------------------------------------------------------
    function isWindows() {
        return ($.os.toString().indexOf("Windows") !== -1);
    }

    function pad(num, size) {
        var s = String(num);
        while (s.length < size) { s = "0" + s; }
        return s;
    }

    // Comilla segura para rutas en linea de comandos. Las rutas del sistema no
    // suelen contener comillas dobles; las eliminamos por seguridad.
    function q(s) {
        return '"' + String(s).replace(/"/g, "") + '"';
    }

    function fileExists(path) {
        if (!path) { return false; }
        return new File(path).exists;
    }

    // Inserta un sufijo antes de la extension: out.mov -> out_seg001.mov
    function insertSuffix(fsName, suffix) {
        var dot = fsName.lastIndexOf(".");
        var slash = Math.max(fsName.lastIndexOf("/"), fsName.lastIndexOf("\\"));
        if (dot === -1 || dot < slash) {
            return fsName + suffix;              // sin extension
        }
        return fsName.substring(0, dot) + suffix + fsName.substring(dot);
    }

    function getExtension(fsName) {
        var dot = fsName.lastIndexOf(".");
        var slash = Math.max(fsName.lastIndexOf("/"), fsName.lastIndexOf("\\"));
        if (dot === -1 || dot < slash) { return ""; }
        return fsName.substring(dot); // incluye el punto
    }

    // Detecta salidas de secuencia de imagenes (contienen un token de numeracion
    // tipo [####] o #). En ese caso NO se anade sufijo por segmento: cada
    // instancia escribe fotogramas de distinto numero en la MISMA secuencia
    // continua, por lo que nunca colisionan y no hay nada que unir.
    function isSequenceOutput(fsName) {
        return /[#\[]/.test(String(fsName));
    }

    // Nombre de salida para un segmento: sufijo _seg### solo si es video.
    function outputNameForSegment(baseOutput, seg) {
        if (isSequenceOutput(baseOutput)) { return baseOutput; }
        return insertSuffix(baseOutput, "_seg" + pad(seg.index, 3));
    }

    // -------------------------------------------------------------------------
    // Persistencia de preferencias (app.settings)
    // -------------------------------------------------------------------------
    var Settings = {
        get: function (key, def) {
            try {
                if (app.settings.haveSetting(APP.settingsSection, key)) {
                    return app.settings.getSetting(APP.settingsSection, key);
                }
            } catch (e) {}
            return def;
        },
        set: function (key, value) {
            try {
                app.settings.saveSetting(APP.settingsSection, key, String(value));
            } catch (e) {}
        }
    };

    // -------------------------------------------------------------------------
    // Deteccion de aerender
    // -------------------------------------------------------------------------
    function guessAerenderPath() {
        // 1) Preferencia guardada
        var saved = Settings.get("aerenderPath", "");
        if (fileExists(saved)) { return saved; }

        // 2) Relativo a la app en ejecucion (mismo directorio que After Effects)
        try {
            var appFolder = Folder.appPackage || new File($.fileName).parent;
        } catch (e) {}

        var candidates = [];
        if (isWindows()) {
            // Rutas tipicas de instalacion en Windows
            var pf = Folder("C:/Program Files/Adobe");
            candidates = collectAerenderWin(pf);
        } else {
            var apps = Folder("/Applications");
            candidates = collectAerenderMac(apps);
        }
        for (var i = 0; i < candidates.length; i++) {
            if (candidates[i].exists) { return candidates[i].fsName; }
        }
        return saved || "";
    }

    function collectAerenderWin(adobeFolder) {
        var out = [];
        try {
            if (adobeFolder && adobeFolder.exists) {
                var subs = adobeFolder.getFiles();
                for (var i = 0; i < subs.length; i++) {
                    if (subs[i] instanceof Folder &&
                        subs[i].name.indexOf("After Effects") !== -1) {
                        out.push(new File(subs[i].fsName + "/Support Files/aerender.exe"));
                        out.push(new File(subs[i].fsName + "/aerender.exe"));
                    }
                }
            }
        } catch (e) {}
        // Ordenar para que las versiones mas recientes queden primero
        out.reverse();
        return out;
    }

    function collectAerenderMac(appsFolder) {
        var out = [];
        try {
            if (appsFolder && appsFolder.exists) {
                var subs = appsFolder.getFiles();
                for (var i = 0; i < subs.length; i++) {
                    if (subs[i] instanceof Folder &&
                        subs[i].name.indexOf("Adobe After Effects") !== -1) {
                        out.push(new File(subs[i].fsName + "/aerender"));
                    }
                }
            }
        } catch (e) {}
        out.reverse();
        return out;
    }

    // -------------------------------------------------------------------------
    // Composicion activa y matematica de segmentos
    // -------------------------------------------------------------------------
    function getActiveComp() {
        var item = app.project ? app.project.activeItem : null;
        if (item && item instanceof CompItem) { return item; }
        // Alternativa: primera comp seleccionada
        if (app.project) {
            var sel = app.project.selection;
            for (var i = 0; i < sel.length; i++) {
                if (sel[i] instanceof CompItem) { return sel[i]; }
            }
        }
        return null;
    }

    function frameOf(timeInSeconds, fps) {
        return Math.round(timeInSeconds * fps);
    }

    /*
     * Calcula los segmentos como rangos de fotogramas [startFrame, endFrame]
     * INCLUSIVOS, relativos al inicio de la composicion (frame 0 = time 0).
     * Reparte el resto de la division entre los primeros segmentos para no
     * perder ni duplicar fotogramas.
     */
    function computeSegments(startFrame, totalFrames, count) {
        var segs = [];
        if (count < 1) { count = 1; }
        if (count > totalFrames) { count = totalFrames; } // no mas segmentos que frames
        var base = Math.floor(totalFrames / count);
        var rem = totalFrames % count;
        var cursor = startFrame;
        for (var i = 0; i < count; i++) {
            var len = base + (i < rem ? 1 : 0);
            var s = cursor;
            var e = cursor + len - 1; // inclusivo
            segs.push({ index: i + 1, startFrame: s, endFrame: e, frames: len });
            cursor += len;
        }
        return segs;
    }

    // -------------------------------------------------------------------------
    // Consulta de plantillas de Render Settings / Output Module
    // -------------------------------------------------------------------------
    function queryTemplates(comp) {
        var result = { rs: ["Best Settings"], om: ["Lossless"] };
        if (!comp) { return result; }
        var rq = app.project.renderQueue;
        var tempItem = null;
        try {
            tempItem = rq.items.add(comp);
            var rsList = tempItem.templates;      // array de nombres
            var omList = tempItem.outputModule(1).templates;
            if (rsList && rsList.length) { result.rs = rsList; }
            if (omList && omList.length) { result.om = omList; }
        } catch (e) {
            // Se conservan los valores por defecto
        } finally {
            if (tempItem) { try { tempItem.remove(); } catch (e2) {} }
        }
        return result;
    }

    // -------------------------------------------------------------------------
    // Estrategia 1: Render secuencial usando la cola de AE
    // -------------------------------------------------------------------------
    function renderInQueue(cfg) {
        var comp = cfg.comp;
        var rq = app.project.renderQueue;
        var fps = comp.frameRate;
        var added = [];

        for (var i = 0; i < cfg.segments.length; i++) {
            var seg = cfg.segments[i];
            var item = rq.items.add(comp);

            // Aplicar plantilla de Render Settings
            if (cfg.rsTemplate) {
                try { item.applyTemplate(cfg.rsTemplate); } catch (e) {}
            }
            // Rango de tiempo del segmento (segundos, base 0)
            item.timeSpanStart = seg.startFrame / fps;
            item.timeSpanDuration = seg.frames / fps;

            // Modulo de salida + archivo
            var om = item.outputModule(1);
            if (cfg.omTemplate) {
                try { om.applyTemplate(cfg.omTemplate); } catch (e) {}
            }
            var outName = outputNameForSegment(cfg.outputFile, seg);
            om.file = new File(outName);
            added.push(item);
        }

        if (cfg.startNow) {
            rq.render(); // bloquea AE hasta terminar todos los items en cola
        }
        return added.length;
    }

    // -------------------------------------------------------------------------
    // Estrategia 2: Render paralelo con aerender (segundo plano)
    // -------------------------------------------------------------------------
    /*
     * Guarda una copia del proyecto, genera un script lanzador que arranca una
     * instancia de aerender por segmento en paralelo, espera a que todas
     * terminen y (opcionalmente) une el resultado con ffmpeg.
     * Devuelve un objeto con las rutas generadas.
     */
    function renderParallel(cfg) {
        if (!fileExists(cfg.aerenderPath)) {
            throw new Error("No se encontro aerender. Indica su ruta en el panel.");
        }
        var comp = cfg.comp;

        // Carpeta de trabajo (junto a la salida) para copia de proyecto y logs
        var outFile = new File(cfg.outputFile);
        var workFolder = new Folder(outFile.parent.fsName + "/JCMega_RenderSegments");
        if (!workFolder.exists) { workFolder.create(); }

        // 1) Guardar copia del proyecto (aerender necesita un .aep en disco)
        var projCopy = new File(workFolder.fsName + "/_render_" + nowStamp() + ".aep");
        app.project.save(projCopy); // guarda el proyecto actual en la copia

        // 2) Construir comandos por segmento
        var seExclusive = cfg.endExclusive; // ajuste opcional de -e
        var cmds = [];
        var segFiles = [];
        for (var i = 0; i < cfg.segments.length; i++) {
            var seg = cfg.segments[i];
            var outName = outputNameForSegment(cfg.outputFile, seg);
            segFiles.push(outName);
            var eFrame = seExclusive ? (seg.endFrame + 1) : seg.endFrame;

            var parts = [
                q(cfg.aerenderPath),
                "-project", q(projCopy.fsName),
                "-comp", q(comp.name),
                "-s", seg.startFrame,
                "-e", eFrame,
                "-output", q(outName)
            ];
            if (cfg.rsTemplate) { parts.push("-RStemplate", q(cfg.rsTemplate)); }
            if (cfg.omTemplate) { parts.push("-OMtemplate", q(cfg.omTemplate)); }
            parts.push("-sound", "ON");
            parts.push("-continueOnMissingFootage");
            cmds.push(parts.join(" "));
        }

        // 3) Comando de union (ffmpeg concat) si procede
        var concatCmd = null;
        var listFile = null;
        if (cfg.concat && !isSequenceOutput(cfg.outputFile) &&
            fileExists(cfg.ffmpegPath) && getExtension(cfg.outputFile) !== "") {
            listFile = new File(workFolder.fsName + "/concat_list.txt");
            var lines = [];
            for (var j = 0; j < segFiles.length; j++) {
                // El demuxer concat usa comillas simples y escapa las internas
                var p = new File(segFiles[j]).fsName.replace(/'/g, "'\\''");
                lines.push("file '" + p + "'");
            }
            writeTextFile(listFile, lines.join("\n"));
            concatCmd = [
                q(cfg.ffmpegPath), "-y", "-f", "concat", "-safe", "0",
                "-i", q(listFile.fsName), "-c", "copy", q(cfg.outputFile)
            ].join(" ");
        }

        // 4) Escribir el lanzador segun plataforma
        var launcher = writeLauncher(workFolder, cmds, concatCmd, cfg.autoLaunch);

        // 5) Lanzar (si el usuario lo pidio)
        if (cfg.autoLaunch) {
            launchDetached(launcher);
        }

        return {
            workFolder: workFolder.fsName,
            projectCopy: projCopy.fsName,
            launcher: launcher.fsName,
            segments: segFiles,
            concat: concatCmd ? cfg.outputFile : null
        };
    }

    function nowStamp() {
        var d = new Date();
        return "" + d.getFullYear() + pad(d.getMonth() + 1, 2) + pad(d.getDate(), 2) +
               "_" + pad(d.getHours(), 2) + pad(d.getMinutes(), 2) + pad(d.getSeconds(), 2);
    }

    function writeTextFile(file, content) {
        file.open("w");
        file.encoding = "UTF-8";
        file.lineFeed = isWindows() ? "Windows" : "Unix";
        file.write(content);
        file.close();
    }

    /*
     * Genera el script lanzador:
     *  - Windows: un sub-.bat por segmento (aerender + marcador .done) y un .bat
     *    maestro que los lanza en paralelo con "start", espera los marcadores y
     *    ejecuta la union. Los sub-bats evitan todo el infierno de escapado de
     *    caracteres especiales dentro de "start ... cmd /c".
     *  - macOS/Linux (.command): lanza cada segmento con "&", "wait" y union.
     */
    function writeLauncher(workFolder, cmds, concatCmd, autoLaunch) {
        var i, lines, launcher;

        if (isWindows()) {
            // 1) Sub-bat por segmento: ejecuta aerender y crea su marcador .done
            for (i = 0; i < cmds.length; i++) {
                var segName = "seg" + pad(i + 1, 3);
                var subBat = new File(workFolder.fsName + "/" + segName + ".bat");
                writeTextFile(subBat, [
                    "@echo off",
                    'cd /d "' + workFolder.fsName + '"',
                    cmds[i],
                    'echo done> "' + segName + '.done"'
                ].join("\r\n"));
            }
            // 2) Bat maestro: limpia marcadores, lanza en paralelo, espera, une
            launcher = new File(workFolder.fsName + "/run_segments.bat");
            lines = ["@echo off", "setlocal", 'cd /d "' + workFolder.fsName + '"',
                     "del /q seg*.done 2>nul",
                     "echo [JCMega Render Segments] Iniciando " + cmds.length + " segmentos..."];
            for (i = 0; i < cmds.length; i++) {
                var sn = "seg" + pad(i + 1, 3);
                lines.push('start "JCMega ' + sn + '" /min cmd /c "' + sn + '.bat"');
            }
            if (concatCmd) {
                lines.push(":waitloop");
                lines.push("timeout /t 3 /nobreak >nul");
                for (i = 0; i < cmds.length; i++) {
                    lines.push('if not exist "seg' + pad(i + 1, 3) + '.done" goto waitloop');
                }
                lines.push("echo [JCMega] Segmentos listos. Uniendo con ffmpeg...");
                lines.push(concatCmd);
            }
            lines.push("echo [JCMega] Proceso finalizado.");
            if (!autoLaunch) { lines.push("pause"); }
            writeTextFile(launcher, lines.join("\r\n"));
        } else {
            launcher = new File(workFolder.fsName + "/run_segments.command");
            lines = ["#!/bin/sh",
                     'cd "' + workFolder.fsName + '"',
                     'echo "[JCMega Render Segments] Iniciando ' + cmds.length + ' segmentos..."'];
            for (i = 0; i < cmds.length; i++) {
                lines.push(cmds[i] + " &");
            }
            lines.push("wait");
            if (concatCmd) {
                lines.push('echo "[JCMega] Segmentos listos. Uniendo con ffmpeg..."');
                lines.push(concatCmd);
            }
            lines.push('echo "[JCMega] Proceso finalizado."');
            writeTextFile(launcher, lines.join("\n"));
            // Permisos de ejecucion
            try { launcher.execute; } catch (e) {}
            try {
                system.callSystem("/bin/chmod +x " + q(launcher.fsName));
            } catch (e2) {}
        }
        return launcher;
    }

    // Lanza el script en segundo plano sin bloquear After Effects.
    function launchDetached(launcher) {
        if (isWindows()) {
            // El .bat usa "start" internamente; cmd /c retorna rapido.
            system.callSystem('cmd.exe /c start "" /min ' + q(launcher.fsName));
        } else {
            system.callSystem('/bin/sh -c ' +
                q('nohup ' + q(launcher.fsName) + ' >/dev/null 2>&1 &'));
        }
    }

    // -------------------------------------------------------------------------
    // Validacion + orquestacion
    // -------------------------------------------------------------------------
    function buildConfigFromUI(ui) {
        var comp = getActiveComp();
        if (!comp) {
            throw new Error("No hay ninguna composicion activa o seleccionada.");
        }
        var count = parseInt(ui.segCount.text, 10);
        if (isNaN(count) || count < 1) {
            throw new Error("El numero de segmentos debe ser un entero >= 1.");
        }

        var fps = comp.frameRate;
        var startFrame, totalFrames;
        if (ui.useWorkArea.value) {
            startFrame = frameOf(comp.workAreaStart, fps);
            totalFrames = frameOf(comp.workAreaDuration, fps);
        } else {
            startFrame = 0;
            totalFrames = frameOf(comp.duration, fps);
        }
        if (totalFrames < 1) {
            throw new Error("El rango a renderizar no tiene fotogramas.");
        }

        var outputFile = ui.outputPath.text;
        if (!outputFile) {
            throw new Error("Selecciona un archivo de salida.");
        }

        return {
            comp: comp,
            segments: computeSegments(startFrame, totalFrames, count),
            rsTemplate: ui.rsTemplate.selection ? ui.rsTemplate.selection.text : "",
            omTemplate: ui.omTemplate.selection ? ui.omTemplate.selection.text : "",
            outputFile: outputFile,
            aerenderPath: ui.aerenderPath.text,
            ffmpegPath: ui.ffmpegPath.text,
            concat: ui.doConcat.value,
            endExclusive: ui.endExclusive.value,
            autoLaunch: true,
            startNow: true
        };
    }

    // -------------------------------------------------------------------------
    // Interfaz (ScriptUI)
    // -------------------------------------------------------------------------
    function buildUI(thisObj) {
        var pal = (thisObj instanceof Panel)
            ? thisObj
            : new Window("palette", APP.name + " v" + APP.version, undefined,
                         { resizeable: true });
        if (pal === null) { return; }

        pal.orientation = "column";
        pal.alignChildren = ["fill", "top"];
        pal.spacing = 8;
        pal.margins = 12;

        var ui = {};

        // --- Cabecera / info de composicion ---
        var head = pal.add("group");
        head.orientation = "column";
        head.alignChildren = ["fill", "top"];
        var title = head.add("statictext", undefined, APP.name);
        try { title.graphics.font = ScriptUI.newFont("dialog", "BOLD", 14); } catch (e) {}
        ui.compInfo = head.add("statictext", undefined, "Composicion: -");
        ui.compInfo.characters = 46;

        // --- Panel: Segmentacion ---
        var pSeg = pal.add("panel", undefined, "Segmentacion");
        pSeg.orientation = "column";
        pSeg.alignChildren = ["fill", "top"];
        pSeg.margins = 12; pSeg.spacing = 6;

        var g1 = pSeg.add("group");
        g1.add("statictext", undefined, "Numero de segmentos:");
        ui.segCount = g1.add("edittext", undefined, Settings.get("segCount", "4"));
        ui.segCount.characters = 5;
        ui.useWorkArea = g1.add("checkbox", undefined, "Solo area de trabajo");
        ui.useWorkArea.value = (Settings.get("useWorkArea", "false") === "true");

        ui.segPreview = pSeg.add("statictext", undefined, "");
        ui.segPreview.characters = 46;

        // --- Panel: Plantillas ---
        var pTpl = pal.add("panel", undefined, "Plantillas de render");
        pTpl.orientation = "column";
        pTpl.alignChildren = ["fill", "top"];
        pTpl.margins = 12; pTpl.spacing = 6;

        var gRs = pTpl.add("group");
        gRs.add("statictext", undefined, "Render Settings:");
        ui.rsTemplate = gRs.add("dropdownlist", undefined, ["Best Settings"]);
        ui.rsTemplate.preferredSize.width = 200;

        var gOm = pTpl.add("group");
        gOm.add("statictext", undefined, "Output Module:");
        ui.omTemplate = gOm.add("dropdownlist", undefined, ["Lossless"]);
        ui.omTemplate.preferredSize.width = 200;

        var gRefresh = pTpl.add("group");
        ui.refreshBtn = gRefresh.add("button", undefined, "Actualizar desde comp");

        // --- Panel: Salida ---
        var pOut = pal.add("panel", undefined, "Salida");
        pOut.orientation = "column";
        pOut.alignChildren = ["fill", "top"];
        pOut.margins = 12; pOut.spacing = 6;

        var gOut = pOut.add("group");
        gOut.alignChildren = ["fill", "center"];
        ui.outputPath = gOut.add("edittext", undefined, Settings.get("outputPath", ""));
        ui.outputPath.characters = 34;
        ui.browseOut = gOut.add("button", undefined, "...");
        ui.browseOut.preferredSize.width = 32;

        var gConcat = pOut.add("group");
        ui.doConcat = gConcat.add("checkbox", undefined, "Unir segmentos con ffmpeg al terminar");
        ui.doConcat.value = (Settings.get("doConcat", "true") === "true");

        // --- Panel: Herramientas externas ---
        var pTools = pal.add("panel", undefined, "Herramientas externas (render paralelo)");
        pTools.orientation = "column";
        pTools.alignChildren = ["fill", "top"];
        pTools.margins = 12; pTools.spacing = 6;

        var gAe = pTools.add("group");
        gAe.alignChildren = ["fill", "center"];
        gAe.add("statictext", undefined, "aerender:");
        ui.aerenderPath = gAe.add("edittext", undefined, guessAerenderPath());
        ui.aerenderPath.characters = 30;
        ui.browseAe = gAe.add("button", undefined, "...");
        ui.browseAe.preferredSize.width = 32;

        var gFf = pTools.add("group");
        gFf.alignChildren = ["fill", "center"];
        gFf.add("statictext", undefined, "ffmpeg:  ");
        ui.ffmpegPath = gFf.add("edittext", undefined, Settings.get("ffmpegPath", ""));
        ui.ffmpegPath.characters = 30;
        ui.browseFf = gFf.add("button", undefined, "...");
        ui.browseFf.preferredSize.width = 32;

        var gEnd = pTools.add("group");
        ui.endExclusive = gEnd.add("checkbox", undefined,
            "Tratar -e como fotograma final EXCLUSIVO");
        ui.endExclusive.value = (Settings.get("endExclusive", "false") === "true");
        ui.endExclusive.helpTip =
            "Actívalo si notas un fotograma duplicado o faltante en los limites de cada segmento.";

        // --- Acciones ---
        var pAct = pal.add("group");
        pAct.orientation = "column";
        pAct.alignChildren = ["fill", "top"];
        pAct.spacing = 6;

        var gA1 = pAct.add("group");
        gA1.alignment = ["fill", "top"];
        ui.queueBtn = gA1.add("button", undefined, "Anadir a la cola de AE");
        ui.parallelBtn = gA1.add("button", undefined, "Renderizar en paralelo");

        var gA2 = pAct.add("group");
        ui.scriptsBtn = gA2.add("button", undefined, "Generar scripts (sin lanzar)");

        ui.status = pal.add("statictext", undefined, "Listo.", { multiline: true });
        ui.status.preferredSize.height = 44;
        ui.status.characters = 46;

        // ---------------------------------------------------------------------
        // Logica de UI
        // ---------------------------------------------------------------------
        function setStatus(msg, isError) {
            ui.status.text = msg;
            try {
                ui.status.graphics.foregroundColor = ui.status.graphics.newPen(
                    ui.status.graphics.PenType.SOLID_COLOR,
                    isError ? [0.95, 0.35, 0.35, 1] : [0.6, 0.85, 0.6, 1], 1);
            } catch (e) {}
        }

        function selectByText(ddl, text) {
            for (var i = 0; i < ddl.items.length; i++) {
                if (ddl.items[i].text === text) { ddl.selection = i; return true; }
            }
            if (ddl.items.length) { ddl.selection = 0; }
            return false;
        }

        function refreshComp() {
            var comp = getActiveComp();
            if (!comp) {
                ui.compInfo.text = "Composicion: (ninguna activa)";
                ui.segPreview.text = "";
                return;
            }
            var fps = comp.frameRate;
            var durFrames = frameOf(comp.duration, fps);
            ui.compInfo.text = "Comp: " + comp.name + "  |  " +
                comp.width + "x" + comp.height + "  |  " +
                fps.toFixed(2) + " fps  |  " + durFrames + " frames";
            updateSegPreview();
        }

        function updateSegPreview() {
            var comp = getActiveComp();
            if (!comp) { ui.segPreview.text = ""; return; }
            var count = parseInt(ui.segCount.text, 10);
            if (isNaN(count) || count < 1) { ui.segPreview.text = "Segmentos: valor no valido"; return; }
            var fps = comp.frameRate;
            var startFrame = ui.useWorkArea.value ? frameOf(comp.workAreaStart, fps) : 0;
            var totalFrames = ui.useWorkArea.value
                ? frameOf(comp.workAreaDuration, fps)
                : frameOf(comp.duration, fps);
            if (totalFrames < 1) { ui.segPreview.text = "Sin fotogramas en el rango."; return; }
            var segs = computeSegments(startFrame, totalFrames, count);
            var min = segs[0].frames, max = segs[0].frames;
            for (var i = 1; i < segs.length; i++) {
                if (segs[i].frames < min) { min = segs[i].frames; }
                if (segs[i].frames > max) { max = segs[i].frames; }
            }
            ui.segPreview.text = segs.length + " segmentos  |  " +
                (min === max ? (min + " frames c/u") : (min + "-" + max + " frames")) +
                "  |  frames " + segs[0].startFrame + "-" + segs[segs.length - 1].endFrame;
        }

        function refreshTemplates() {
            var comp = getActiveComp();
            var t = queryTemplates(comp);
            ui.rsTemplate.removeAll();
            for (var i = 0; i < t.rs.length; i++) { ui.rsTemplate.add("item", t.rs[i]); }
            selectByText(ui.rsTemplate, Settings.get("rsTemplate", "Best Settings"));
            ui.omTemplate.removeAll();
            for (var j = 0; j < t.om.length; j++) { ui.omTemplate.add("item", t.om[j]); }
            selectByText(ui.omTemplate, Settings.get("omTemplate", "Lossless"));
        }

        function persist() {
            Settings.set("segCount", ui.segCount.text);
            Settings.set("useWorkArea", ui.useWorkArea.value);
            Settings.set("outputPath", ui.outputPath.text);
            Settings.set("doConcat", ui.doConcat.value);
            Settings.set("aerenderPath", ui.aerenderPath.text);
            Settings.set("ffmpegPath", ui.ffmpegPath.text);
            Settings.set("endExclusive", ui.endExclusive.value);
            if (ui.rsTemplate.selection) { Settings.set("rsTemplate", ui.rsTemplate.selection.text); }
            if (ui.omTemplate.selection) { Settings.set("omTemplate", ui.omTemplate.selection.text); }
        }

        // --- Eventos ---
        ui.segCount.onChanging = updateSegPreview;
        ui.useWorkArea.onClick = updateSegPreview;
        ui.refreshBtn.onClick = function () {
            refreshComp();
            refreshTemplates();
            setStatus("Composicion y plantillas actualizadas.", false);
        };

        ui.browseOut.onClick = function () {
            var f = File.saveDialog("Archivo de salida base", "*.*");
            if (f) { ui.outputPath.text = f.fsName; }
        };
        ui.browseAe.onClick = function () {
            var f = File.openDialog("Selecciona aerender");
            if (f) { ui.aerenderPath.text = f.fsName; }
        };
        ui.browseFf.onClick = function () {
            var f = File.openDialog("Selecciona ffmpeg");
            if (f) { ui.ffmpegPath.text = f.fsName; }
        };

        ui.queueBtn.onClick = function () {
            try {
                persist();
                var cfg = buildConfigFromUI(ui);
                cfg.startNow = false; // solo anadir; el usuario decide cuando renderizar
                var n = renderInQueue(cfg);
                setStatus(n + " segmentos anadidos a la cola de render. Pulsa Render en AE.", false);
            } catch (e) {
                setStatus("Error: " + e.message, true);
            }
        };

        ui.parallelBtn.onClick = function () {
            try {
                persist();
                if (app.project.file === null) {
                    throw new Error("Guarda el proyecto (.aep) antes de renderizar en paralelo.");
                }
                var cfg = buildConfigFromUI(ui);
                cfg.autoLaunch = true;
                var res = renderParallel(cfg);
                setStatus("Lanzados " + cfg.segments.length +
                    " segmentos en paralelo.\nCarpeta: " + res.workFolder, false);
            } catch (e) {
                setStatus("Error: " + e.message, true);
            }
        };

        ui.scriptsBtn.onClick = function () {
            try {
                persist();
                if (app.project.file === null) {
                    throw new Error("Guarda el proyecto (.aep) antes de generar los scripts.");
                }
                var cfg = buildConfigFromUI(ui);
                cfg.autoLaunch = false;
                var res = renderParallel(cfg);
                setStatus("Scripts generados (no lanzados).\nLanzador: " + res.launcher, false);
            } catch (e) {
                setStatus("Error: " + e.message, true);
            }
        };

        // Init
        refreshComp();
        refreshTemplates();

        // Layout final
        if (pal instanceof Window) {
            pal.center();
            pal.show();
        } else {
            pal.layout.layout(true);
            pal.layout.resize();
            pal.onResizing = pal.onResize = function () { this.layout.resize(); };
        }

        return pal;
    }

    // -------------------------------------------------------------------------
    // Arranque
    // -------------------------------------------------------------------------
    if (app === undefined || app.project === undefined) {
        alert("Este script debe ejecutarse dentro de Adobe After Effects.");
        return;
    }
    buildUI(thisObj);

})(this);
