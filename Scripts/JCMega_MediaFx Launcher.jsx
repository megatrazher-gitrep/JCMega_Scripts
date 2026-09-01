/**
 * JCMega MediaFx Launcher
 * -----------------------------------------------------------------------------
 * Script para Adobe After Effects que visualiza (y permite ejecutar) todos los
 * archivos .jsx cuyo nombre contenga "JC MediaFx", ubicados en:
 *
 *   C:\Program Files\Adobe\Adobe After Effects 2025\Support Files\Scripts
 *
 * Creado por JC / MegaTrazher.
 *
 * Uso:
 *   - Abrir desde: Archivo > Scripts > Ejecutar archivo de script...  (o)
 *   - Colocar en la carpeta "ScriptUI Panels" para tenerlo como panel acoplable
 *     en el menu Ventana.
 * -----------------------------------------------------------------------------
 */

(function jcMegaMediaFxLauncher(thisObj) {
    // ---------------------------------------------------------------------
    // Configuracion
    // ---------------------------------------------------------------------
    var SCRIPT_NAME   = "JCMega MediaFx Launcher";
    var NAME_FILTER   = "JC MediaFx";   // texto que debe contener el nombre
    var SCAN_RECURSE  = true;           // buscar tambien en subcarpetas

    // Ruta objetivo indicada por el usuario.
    var TARGET_PATH = "C:\\Program Files\\Adobe\\Adobe After Effects 2025\\Support Files\\Scripts";

    // ---------------------------------------------------------------------
    // Utilidades
    // ---------------------------------------------------------------------

    /**
     * Devuelve una carpeta valida donde buscar. Si la ruta objetivo no existe
     * (otra version de AE, macOS, etc.) intenta deducir la carpeta Scripts de
     * la instalacion actual de After Effects.
     */
    function resolveScriptsFolder() {
        var target = new Folder(TARGET_PATH);
        if (target.exists) { return target; }

        // Alternativa: carpeta Scripts de la instalacion en ejecucion.
        try {
            var appScripts = new Folder(Folder.appPackage.fsName + "/Scripts");
            if (appScripts.exists) { return appScripts; }
        } catch (e) {}

        return target; // se devuelve aunque no exista, para avisar al usuario.
    }

    /**
     * Recorre una carpeta buscando archivos .jsx / .jsxbin cuyo nombre contenga
     * el filtro (sin distinguir mayusculas/minusculas).
     * @return {Array} lista de objetos File.
     */
    function findMediaFxScripts(folder, recurse) {
        var results = [];
        if (!folder || !folder.exists) { return results; }

        var filterLower = NAME_FILTER.toLowerCase();
        var items = folder.getFiles();
        if (!items) { return results; }

        for (var i = 0; i < items.length; i++) {
            var item = items[i];

            if (item instanceof Folder) {
                if (recurse) {
                    results = results.concat(findMediaFxScripts(item, recurse));
                }
                continue;
            }

            var name = decodeURI(item.name);
            var lower = name.toLowerCase();
            var isJsx = (/\.jsx(bin)?$/i).test(name);

            if (isJsx && lower.indexOf(filterLower) !== -1) {
                results.push(item);
            }
        }
        return results;
    }

    /** Ordena archivos por nombre (alfabetico, sin distinguir mayusculas). */
    function sortByName(files) {
        files.sort(function (a, b) {
            var na = decodeURI(a.name).toLowerCase();
            var nb = decodeURI(b.name).toLowerCase();
            return (na < nb) ? -1 : (na > nb) ? 1 : 0;
        });
        return files;
    }

    /** Tamano legible del archivo. */
    function humanSize(bytes) {
        if (bytes === undefined || bytes === null) { return "-"; }
        if (bytes < 1024) { return bytes + " B"; }
        if (bytes < 1024 * 1024) { return (bytes / 1024).toFixed(1) + " KB"; }
        return (bytes / (1024 * 1024)).toFixed(1) + " MB";
    }

    // ---------------------------------------------------------------------
    // Construccion de la interfaz
    // ---------------------------------------------------------------------
    function buildUI(thisObj) {
        var win = (thisObj instanceof Panel)
            ? thisObj
            : new Window("palette", SCRIPT_NAME, undefined, { resizeable: true });

        win.orientation = "column";
        win.alignChildren = ["fill", "fill"];
        win.spacing = 8;
        win.margins = 12;

        // --- Cabecera / info de ruta -------------------------------------
        var header = win.add("panel", undefined, "Carpeta de scripts");
        header.orientation = "column";
        header.alignChildren = ["fill", "top"];
        header.margins = 10;

        var pathText = header.add("statictext", undefined, "", { truncate: "middle" });
        pathText.alignment = ["fill", "top"];

        var countText = header.add("statictext", undefined, "");
        countText.alignment = ["fill", "top"];

        // --- Lista de scripts encontrados --------------------------------
        var list = win.add("listbox", undefined, [], {
            numberofColumns: 2,
            showHeaders: true,
            columnTitles: ["Script (.jsx)", "Tamano"],
            columnWidths: [300, 80],
            multiselect: false
        });
        list.alignment = ["fill", "fill"];
        list.preferredSize = [420, 260];

        // --- Botonera ----------------------------------------------------
        var actions = win.add("group");
        actions.orientation = "row";
        actions.alignment = ["fill", "bottom"];
        actions.alignChildren = ["left", "center"];
        actions.spacing = 6;

        var btnRun     = actions.add("button", undefined, "Ejecutar");
        var btnReveal  = actions.add("button", undefined, "Mostrar en carpeta");
        var btnRefresh = actions.add("button", undefined, "Refrescar");

        var spring = actions.add("group");
        spring.alignment = ["fill", "center"];

        var btnClose = actions.add("button", undefined, "Cerrar");

        // --- Estado interno ---------------------------------------------
        var currentFolder = null;
        var currentFiles  = [];

        // ---------------------------------------------------------------------
        // Logica
        // ---------------------------------------------------------------------
        function refresh() {
            currentFolder = resolveScriptsFolder();
            pathText.text = currentFolder.fsName;

            list.removeAll();
            currentFiles = [];

            if (!currentFolder.exists) {
                countText.text = "La carpeta no existe en este equipo.";
                updateButtons();
                return;
            }

            currentFiles = sortByName(findMediaFxScripts(currentFolder, SCAN_RECURSE));

            for (var i = 0; i < currentFiles.length; i++) {
                var f = currentFiles[i];
                var item = list.add("item", decodeURI(f.name));
                item.subItems[0].text = humanSize(f.length);
                item.jcFile = f; // referencia al File original
            }

            countText.text = currentFiles.length === 0
                ? "No se encontraron scripts con \"" + NAME_FILTER + "\" en el nombre."
                : "Se encontraron " + currentFiles.length + " script(s) con \"" + NAME_FILTER + "\".";

            if (currentFiles.length > 0) { list.selection = 0; }
            updateButtons();
        }

        function selectedFile() {
            if (list.selection && list.selection.jcFile) {
                return list.selection.jcFile;
            }
            return null;
        }

        function runSelected() {
            var f = selectedFile();
            if (!f) { return; }
            if (!f.exists) {
                alert("El archivo ya no existe:\n" + f.fsName, SCRIPT_NAME);
                refresh();
                return;
            }
            try {
                // $.evalFile ejecuta el script en el contexto de After Effects.
                app.beginUndoGroup(SCRIPT_NAME + ": " + decodeURI(f.name));
                $.evalFile(f);
            } catch (err) {
                alert("Error al ejecutar el script:\n" + decodeURI(f.name) +
                      "\n\n" + err.toString(), SCRIPT_NAME);
            } finally {
                try { app.endUndoGroup(); } catch (e2) {}
            }
        }

        function revealSelected() {
            var f = selectedFile();
            var target = f ? f : currentFolder;
            if (target && target.exists) {
                try { target.execute(); } catch (e) {
                    // Alternativa: abrir la carpeta contenedora.
                    if (f && f.parent) { f.parent.execute(); }
                }
            }
        }

        function updateButtons() {
            var hasSel = !!selectedFile();
            btnRun.enabled = hasSel;
            btnReveal.enabled = hasSel || (currentFolder && currentFolder.exists);
        }

        // ---------------------------------------------------------------------
        // Eventos
        // ---------------------------------------------------------------------
        list.onChange = updateButtons;
        list.onDoubleClick = runSelected;

        btnRun.onClick     = runSelected;
        btnReveal.onClick  = revealSelected;
        btnRefresh.onClick = refresh;
        btnClose.onClick   = function () {
            if (win instanceof Window) { win.close(); }
        };

        // Redimensionado (solo ventana flotante).
        win.onResizing = win.onResize = function () { this.layout.resize(); };

        // ---------------------------------------------------------------------
        // Inicio
        // ---------------------------------------------------------------------
        refresh();

        if (win instanceof Window) {
            win.center();
            win.show();
        } else {
            win.layout.layout(true);
            win.layout.resize();
        }

        return win;
    }

    // Comprobacion basica de entorno.
    if (typeof app === "undefined" || !(app instanceof Application)) {
        // Fuera de After Effects no hay nada que hacer.
        return;
    }

    buildUI(thisObj);

})(this);
