/*
 JCMega EGP Auto Builder PRO v4.1
 After Effects CC 2019+ / optimizado para AE 2022+ (algunas funciones requieren AE 2020/2022)

 Objetivo:
   Automatizar la creacion de plantillas de Motion Graphics (MOGRT) desde el panel
   Essential Graphics (EGP): detectar capas de forma inteligente, agregar las
   propiedades adecuadas al panel, crear Expression Controls vinculados y, finalmente,
   EXPORTAR el archivo .mogrt.

 Funciones:
 - Modo inteligente por tipo de capa (texto, control/null, imagen/footage, grafico).
 - Agregar propiedades seleccionadas directamente a EGP con etiquetas legibles.
 - Crear controles Expression Control y vincularlos automaticamente a las propiedades.
 - Soporta Slider, Angle, Point, 3D Point, Checkbox, Color y Dropdown segun el tipo.
 - Analizador de composicion y de seleccion.
 - Exportar el archivo .mogrt (exportAsMotionGraphicsTemplate).
 - Normalizacion de nombres de controladores EGP.
 - Gestor de grupos logicos (prefijos GRUPO > ELEMENTO).
 - Cierre de la composicion en EGP mediante automatizacion de UI (solo Windows).

 NOTAS SOBRE LA API:
   Adobe expone openInEssentialGraphics(), el conteo/nombres de controladores EGP,
   exportAsMotionGraphicsTemplate() y la API para agregar/renombrar, pero NO expone un
   closeInEssentialGraphics() publico. El boton CERRAR usa automatizacion de teclado de
   Windows (WScript/SendKeys) como ultimo recurso.

 CAMBIOS v4.1 (correcciones sobre v4):
   * autoControlsFromSelection: se corrige la resolucion de la capa a partir de la
     propiedad (antes se perdia la referencia y fallaba la creacion del control).
   * controlTypeForProperty: PropertyValueType.ANGLE no existe en AE; ahora se mapea
     correctamente OneD/TwoD/ThreeD/COLOR y se soportan propiedades 3D.
   * addEffectControl: protegido cuando la capa no admite efectos (camara/luz).
   * Etiquetas EGP mas legibles usando siempre el nombre real de la capa.
   * Nuevo: exportar .mogrt (exportAsMotionGraphicsTemplate) para cumplir el objetivo.
   * Comprobaciones de version y de disponibilidad de API mas robustas.
*/

(function (thisObj) {
    var SCRIPT_NAME = "JCMega EGP Auto Builder PRO";
    var VERSION = "4.1";

    // ------------------------------------------------------------
    // UTILIDADES BASE
    // ------------------------------------------------------------
    function getActiveComp() {
        var item = app.project ? app.project.activeItem : null;
        if (!item || !(item instanceof CompItem)) {
            alert("Selecciona una composicion activa.");
            return null;
        }
        return item;
    }

    function safeCanAdd(prop, comp) {
        try { return !!(prop && prop.canAddToMotionGraphicsTemplate(comp)); }
        catch (e) { return false; }
    }

    function safeAdd(prop, comp, label) {
        if (!safeCanAdd(prop, comp)) return false;
        try {
            if (prop.addToMotionGraphicsTemplateAs) return !!prop.addToMotionGraphicsTemplateAs(comp, label);
            return !!prop.addToMotionGraphicsTemplate(comp);
        } catch (e) { return false; }
    }

    function propByMatch(group, names) {
        if (!group) return null;
        for (var i = 0; i < names.length; i++) {
            try { var p = group.property(names[i]); if (p) return p; } catch (e) {}
        }
        return null;
    }

    function cleanLayerName(name) {
        var s = String(name || "Elemento");
        s = s.replace(/\.(png|jpg|jpeg|gif|tif|tiff|psd|ai|mov|mp4|m4v|avi|webm|mp3|wav|aep)$/i, "");
        return s;
    }

    // Devuelve la CAPA (Layer) que contiene la propiedad p.
    // p.propertyGroup(p.propertyDepth) sube exactamente hasta el nivel de la capa.
    function layerOfProperty(p) {
        try { return p.propertyGroup(p.propertyDepth); }
        catch (e) { return null; }
    }

    // Etiqueta legible: "NombreCapa — Propiedad" (o con el grupo intermedio si aporta).
    function bestPropLabel(p) {
        var layerName = "Elemento";
        var lay = layerOfProperty(p);
        if (lay && lay.name) layerName = cleanLayerName(lay.name);
        var group = "";
        try {
            var pg = p.propertyGroup(1);
            if (pg && pg.name && lay && pg.name !== lay.name && pg.name !== "Transform" && pg.name !== "Transformar") {
                group = pg.name + " — ";
            }
        } catch (e) {}
        return layerName + " — " + group + p.name;
    }

    // La capa admite efectos (solo AVLayer con Effect Parade; no camaras/luces).
    function effectParadeOf(layer) {
        if (!layer) return null;
        try {
            var fx = layer.property("ADBE Effect Parade");
            return fx || null;
        } catch (e) { return null; }
    }

    // ------------------------------------------------------------
    // BUILDER
    // ------------------------------------------------------------
    function addTransform(layer, comp, options, stats) {
        var tr = null;
        try { tr = layer.property("ADBE Transform Group"); } catch (e) {}
        if (!tr) return;
        var base = cleanLayerName(layer.name);
        function add(p, label) {
            if (!p) return;
            if (safeAdd(p, comp, label)) stats.added++;
            else stats.skipped++;
        }
        if (options.position) add(propByMatch(tr, ["ADBE Position"]), base + " — Posicion");
        if (options.scale)    add(propByMatch(tr, ["ADBE Scale"]), base + " — Escala");
        if (options.rotation) add(propByMatch(tr, ["ADBE Rotate Z", "ADBE Rotation"]), base + " — Rotacion");
        if (options.opacity)  add(propByMatch(tr, ["ADBE Opacity"]), base + " — Opacidad");
    }

    function addText(layer, comp, stats) {
        var p = null;
        try { p = layer.property("ADBE Text Properties").property("ADBE Text Document"); } catch (e) {}
        if (!p) { try { p = layer.property("Source Text"); } catch (e2) {} }
        if (p && safeAdd(p, comp, cleanLayerName(layer.name) + " — Texto")) stats.added++;
        else if (p) stats.skipped++;
    }

    function addEffectProperties(layer, comp, stats, onlyBlur) {
        var effects = effectParadeOf(layer);
        if (!effects) return;
        for (var i = 1; i <= effects.numProperties; i++) {
            var fx = effects.property(i); if (!fx) continue;
            var fxName = String(fx.name || "").toLowerCase();
            var isBlur = fxName.indexOf("blur") >= 0 || fxName.indexOf("desenfoque") >= 0 ||
                         fxName.indexOf("gaussian") >= 0 || fxName.indexOf("gaussiano") >= 0;
            if (onlyBlur && !isBlur) continue;
            for (var j = 1; j <= fx.numProperties; j++) {
                var p = fx.property(j); if (!p) continue;
                if (p.numProperties && p.propertyType === PropertyType.INDEXED_GROUP) {
                    for (var k = 1; k <= p.numProperties; k++) {
                        var nested = p.property(k);
                        if (nested && safeCanAdd(nested, comp)) {
                            if (safeAdd(nested, comp, cleanLayerName(layer.name) + " — " + fx.name + " — " + nested.name)) stats.added++;
                            else stats.skipped++;
                        }
                    }
                } else if (safeCanAdd(p, comp)) {
                    if (safeAdd(p, comp, cleanLayerName(layer.name) + " — " + fx.name + " — " + p.name)) stats.added++;
                    else stats.skipped++;
                }
            }
        }
    }

    function isTextLayer(layer) {
        try { return layer instanceof TextLayer; }
        catch (e) { try { return !!layer.property("ADBE Text Properties"); } catch (e2) { return false; } }
    }
    function isNullLayer(layer) { try { return layer.nullLayer === true; } catch (e) { return false; } }
    function isControlLayer(layer) {
        var n = String(layer.name || "").toLowerCase();
        return isNullLayer(layer) || n.indexOf("control") >= 0 || n.indexOf("ctrl") >= 0 || n.indexOf("controlador") >= 0;
    }
    function isImageLayer(layer) {
        try { return (layer instanceof AVLayer) && !!layer.source && !isTextLayer(layer); }
        catch (e) { return false; }
    }

    function processLayer(layer, comp, options, stats) {
        if (!layer || layer.guideLayer) return;
        var text = isTextLayer(layer), control = isControlLayer(layer), image = isImageLayer(layer);
        if (text && options.text) addText(layer, comp, stats);
        if (options.smart) {
            if (control) addTransform(layer, comp, {position:options.position, scale:options.scale, rotation:false, opacity:false}, stats);
            else if (text) addTransform(layer, comp, {position:options.position, scale:options.scale, rotation:options.rotation, opacity:options.opacity}, stats);
            else if (image) addTransform(layer, comp, {position:false, scale:options.scale, rotation:options.rotation, opacity:options.opacity}, stats);
            else addTransform(layer, comp, {position:options.position, scale:options.scale, rotation:options.rotation, opacity:options.opacity}, stats);
        } else addTransform(layer, comp, options, stats);
        if (options.effects) addEffectProperties(layer, comp, stats, options.onlyBlur);
    }

    function build(options) {
        var comp = getActiveComp(); if (!comp) return;
        var layers = options.selectedOnly ? comp.selectedLayers : null;
        if (options.selectedOnly && (!layers || !layers.length)) { alert("No hay capas seleccionadas."); return; }
        var stats = {added:0, skipped:0};
        app.beginUndoGroup(SCRIPT_NAME + " — Build");
        try {
            try { if (comp.openInEssentialGraphics) comp.openInEssentialGraphics(); } catch (e0) {}
            if (options.selectedOnly) for (var s=0;s<layers.length;s++) processLayer(layers[s], comp, options, stats);
            else for (var i=1;i<=comp.numLayers;i++) processLayer(comp.layer(i), comp, options, stats);
            if (options.templateName !== "") { try { comp.motionGraphicsTemplateName = options.templateName; } catch(e1) {} }
        } finally { app.endUndoGroup(); }
        alert("JCMega EGP Auto Builder PRO\n\nControles agregados: " + stats.added +
              "\nOmitidos/no compatibles/ya existentes: " + stats.skipped);
    }

    // ------------------------------------------------------------
    // ANALIZADOR
    // ------------------------------------------------------------
    function analyzeComp() {
        var comp = getActiveComp(); if (!comp) return;
        var lines = [];
        lines.push("JCMega EGP ANALYZER v" + VERSION);
        lines.push("Composicion: " + comp.name);
        lines.push("Capas: " + comp.numLayers);
        try { lines.push("Controladores EGP actuales: " + comp.motionGraphicsTemplateControllerCount); }
        catch(e) { lines.push("Controladores EGP actuales: no disponible"); }
        lines.push("");
        for (var i=1;i<=comp.numLayers;i++) {
            var l=comp.layer(i); if (!l) continue;
            var kind=isTextLayer(l)?"TEXTO":(isNullLayer(l)?"NULL/CONTROL":(isImageLayer(l)?"IMAGEN/FOOTAGE":"GRAFICO"));
            var tr="";
            try {
                var tg=l.property("ADBE Transform Group");
                if(tg) tr="P="+(tg.property("ADBE Position")?"si":"—")+"  S="+(tg.property("ADBE Scale")?"si":"—")+
                        "  R="+(tg.property("ADBE Rotate Z")?"si":"—")+"  O="+(tg.property("ADBE Opacity")?"si":"—");
            } catch(e2) {}
            lines.push(i+". ["+kind+"] "+l.name+(tr?"  |  "+tr:""));
        }
        try {
            lines.push(""); lines.push("--- CONTROLES EGP ---");
            for(var c=1;c<=comp.motionGraphicsTemplateControllerCount;c++)
                lines.push(c+". "+comp.getMotionGraphicsTemplateControllerName(c));
        } catch(e3) {}
        showReport("ANALISIS DE COMPOSICION", lines.join("\n"));
    }

    function analyzeSelection() {
        var comp=getActiveComp(); if(!comp) return;
        var props=comp.selectedProperties || [];
        if(!props.length){ alert("Selecciona una o mas propiedades en Timeline/Effect Controls."); return; }
        var lines=["PROPIEDADES SELECCIONADAS: "+props.length,""];
        for(var i=0;i<props.length;i++){
            var p=props[i];
            lines.push((i+1)+". "+p.name+" | matchName="+p.matchName+" | valueType="+p.propertyValueType+
                       " | canAddEGP="+safeCanAdd(p,comp));
        }
        showReport("ANALIZAR SELECCION",lines.join("\n"));
    }

    function showReport(title,text){
        var w=new Window("dialog",title,undefined,{resizeable:true});
        w.orientation="column"; w.alignChildren=["fill","fill"]; w.margins=12;
        var box=w.add("edittext",undefined,text,{multiline:true,scrolling:true}); box.preferredSize=[700,420];
        var row=w.add("group"); row.alignment="right";
        row.add("button",undefined,"Cerrar",{name:"ok"}).onClick=function(){w.close();};
        w.center(); w.show();
    }

    // ------------------------------------------------------------
    // AGREGAR SELECCION DIRECTA
    // ------------------------------------------------------------
    function addSelectedPropertiesToEGP() {
        var comp=getActiveComp(); if(!comp) return;
        var props=comp.selectedProperties || [];
        if(!props.length){ alert("Selecciona propiedades en la Timeline o Effect Controls."); return; }
        var added=0, skipped=0;
        app.beginUndoGroup(SCRIPT_NAME+" — Add Selected");
        try{
            try { if (comp.openInEssentialGraphics) comp.openInEssentialGraphics(); } catch (e0) {}
            for(var i=0;i<props.length;i++){
                var p=props[i];
                if(safeAdd(p,comp,bestPropLabel(p))) added++; else skipped++;
            }
        }finally{app.endUndoGroup();}
        alert("Propiedades seleccionadas\n\nAgregadas: "+added+"\nOmitidas/no compatibles: "+skipped);
    }

    // ------------------------------------------------------------
    // EXPRESSION CONTROLS AUTOMATICOS
    // ------------------------------------------------------------
    // Devuelve el matchName del efecto de control y el indice de la propiedad de valor.
    function controlSpecForType(type) {
        switch (type) {
            case "slider":   return { match:"ADBE Slider Control",   valueIndex:1 };
            case "angle":    return { match:"ADBE Angle Control",    valueIndex:1 };
            case "point":    return { match:"ADBE Point Control",    valueIndex:1 };
            case "point3d":  return { match:"ADBE Point3D Control",  valueIndex:1 };
            case "checkbox": return { match:"ADBE Checkbox Control", valueIndex:1 };
            case "color":    return { match:"ADBE Color Control",    valueIndex:1 };
            case "dropdown": return { match:"ADBE Dropdown Control", valueIndex:1 };
        }
        return null;
    }

    // Crea un Expression Control en la capa. Devuelve {effect, valueProp} o null.
    function addEffectControl(layer, type, name, value) {
        var fx = effectParadeOf(layer);
        if (!fx) return null; // camaras/luces no admiten efectos
        var spec = controlSpecForType(type);
        if (!spec) return null;
        var e;
        try { e = fx.addProperty(spec.match); }
        catch (err) {
            // "ADBE Point3D Control" no existe en versiones antiguas: usar Point 2D.
            if (type === "point3d") { try { e = fx.addProperty("ADBE Point Control"); } catch (e2) { return null; } }
            else return null;
        }
        if (!e) return null;
        try { e.name = name; } catch (eName) {}
        var vp = null;
        try { vp = e.property(spec.valueIndex); } catch (eVp) {}
        try { if (value !== undefined && vp && vp.canSetValue) vp.setValue(value); } catch (eSet) {}
        return { effect: e, valueProp: vp };
    }

    function controlTypeForProperty(p) {
        try {
            var t = p.propertyValueType;
            if (t === PropertyValueType.OneD)          return "slider"; // incluye rotacion/opacidad/angulos
            if (t === PropertyValueType.TwoD ||
                t === PropertyValueType.TwoD_SPATIAL)  return "point";
            if (t === PropertyValueType.ThreeD ||
                t === PropertyValueType.ThreeD_SPATIAL)return "point3d";
            if (t === PropertyValueType.COLOR)         return "color";
        } catch(e){}
        return null;
    }

    function autoControlsFromSelection() {
        var comp=getActiveComp(); if(!comp) return;
        var props=comp.selectedProperties || [];
        if(!props.length){ alert("Selecciona propiedades que quieras convertir en controles."); return; }
        var created=0, linked=0, direct=0, skipped=0, uid=1;
        app.beginUndoGroup(SCRIPT_NAME+" — Auto Controls");
        try{
            try { if (comp.openInEssentialGraphics) comp.openInEssentialGraphics(); } catch (e0) {}
            for(var i=0;i<props.length;i++){
                var p=props[i];

                // 1) Si la propiedad se puede agregar directamente al EGP, hacerlo.
                if(safeCanAdd(p,comp)){
                    if(safeAdd(p,comp,bestPropLabel(p))) direct++; else skipped++;
                    continue;
                }

                // 2) Si no, crear un Expression Control en su capa y vincularlo.
                var layer = layerOfProperty(p);
                if(!layer || !effectParadeOf(layer)){ skipped++; continue; } // camara/luz o sin capa

                var type = controlTypeForProperty(p);
                if(!type){ skipped++; continue; }

                var ctrlName = "JC CTRL — " + p.name + " (" + (uid++) + ")";
                var ctrl = addEffectControl(layer, type, ctrlName, p.value);
                if(!ctrl || !ctrl.effect){ skipped++; continue; }
                created++;

                // Vincular la propiedad al control mediante expresion (referencia por nombre unico).
                try{
                    if (p.canSetExpression) {
                        var fxName = ctrl.effect.name.replace(/\\/g,'\\\\').replace(/"/g,'\\"');
                        p.expression = 'effect("' + fxName + '")(1)';
                        linked++;
                    }
                }catch(e3){}

                // Exponer el control creado en el panel EGP.
                try{ if(!safeAdd(ctrl.valueProp, comp, cleanLayerName(layer.name)+" — "+p.name)) {} }catch(e4){}
            }
        }finally{app.endUndoGroup();}
        alert("AUTO CONTROLS\n\nControles creados: "+created+
              "\nExpresiones vinculadas: "+linked+
              "\nPropiedades agregadas directamente: "+direct+
              "\nOmitidas: "+skipped);
    }

    // ------------------------------------------------------------
    // EXPORTAR .MOGRT
    // ------------------------------------------------------------
    function exportMogrt(templateName) {
        var comp = getActiveComp(); if (!comp) return;

        if (typeof comp.exportAsMotionGraphicsTemplate !== "function") {
            alert("Tu version de After Effects no expone exportAsMotionGraphicsTemplate().\n" +
                  "Requiere AE 2020 (17.0) o superior.\n\n" +
                  "Puedes exportar manualmente desde el panel Essential Graphics con el boton 'Export Motion Graphics Template'.");
            return;
        }

        var count = 0;
        try { count = comp.motionGraphicsTemplateControllerCount; } catch (e) {}
        if (!count) {
            if (!confirm("La composicion no tiene controles en Essential Graphics.\n\n" +
                         "¿Exportar el .mogrt de todas formas?")) return;
        }

        // Fijar el nombre de la plantilla si se indico.
        if (templateName && templateName !== "") {
            try { comp.motionGraphicsTemplateName = templateName; } catch (e1) {}
        }

        // Elegir carpeta de destino. Si el usuario cancela, se usa el dialogo nativo de AE.
        var baseName = String(comp.motionGraphicsTemplateName || comp.name || "Template")
                        .replace(/[\\\/:*?"<>|]/g, "_");
        var ok = false, savedPath = "";
        try {
            var folder = Folder.selectDialog("Elige la carpeta de destino del .mogrt");
            if (folder) {
                var file = new File(folder.fsName + "/" + baseName + ".mogrt");
                ok = comp.exportAsMotionGraphicsTemplate(true, file.fsName);
                savedPath = file.fsName;
            } else {
                // Sin carpeta: abrir el dialogo nativo "Export As Motion Graphics Template".
                ok = comp.exportAsMotionGraphicsTemplate();
            }
        } catch (e2) {
            alert("No se pudo exportar el .mogrt:\n\n" + e2.toString());
            return;
        }

        if (ok) {
            alert("MOGRT exportado correctamente." + (savedPath ? "\n\n" + savedPath : ""));
        } else {
            alert("La exportacion no se completo.\n\n" +
                  "Revisa que la composicion tenga controles validos y que la ruta sea escribible.");
        }
    }

    // ------------------------------------------------------------
    // CERRAR COMPOSICION EN EGP - WINDOWS UI AUTOMATION
    // ------------------------------------------------------------
    function closeCompInEGP() {
        var comp = getActiveComp(); if (!comp) return;
        var compName = String(comp.name || "");
        var count = 0;
        try { count = comp.motionGraphicsTemplateControllerCount; } catch (e) {}

        var isWin = ($.os && $.os.toLowerCase().indexOf("windows") >= 0);
        if (!isWin) {
            alert("El cierre automatico solo esta disponible en Windows.\n\n" +
                  "En macOS, usa el selector Master del panel Essential Graphics y elige:\n" +
                  "Close " + compName + "\n\nLos controles no se eliminan.");
            return;
        }

        var msg = "Cerrar la composicion en Essential Graphics:\n\n" + compName + "\n\n" +
                  "Esto NO elimina ningun control. Solo intenta cerrar la composicion actual del panel EGP.\n\n" +
                  "Si After Effects no permite el cierre por automatizacion, usa el menu Master del panel y elige 'Close " + compName + "'.\n\n" +
                  "Controles actuales: " + count + "\n\n¿Continuar?";
        if (!confirm(msg)) return;

        var ps = "" +
            "$ws=New-Object -ComObject WScript.Shell;" +
            "Start-Sleep -Milliseconds 350;" +
            "$ws.AppActivate('After Effects');" +
            "Start-Sleep -Milliseconds 350;" +
            "$ws.SendKeys('%{DOWN}');" +
            "Start-Sleep -Milliseconds 300;" +
            "$ws.SendKeys('c');" +
            "Start-Sleep -Milliseconds 150;" +
            "$ws.SendKeys('{ENTER}');";

        var cmd = 'powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "' + ps.replace(/"/g, '\\"') + '"';
        try { system.callSystem(cmd); }
        catch (e1) {
            alert("No se pudo ejecutar la automatizacion de Windows.\n\n" + e1.toString());
            return;
        }

        alert("Solicitud de cierre enviada al panel Essential Graphics.\n\n" +
              "No se eliminaron controles.\n\n" +
              "Si la composicion sigue abierta, usa el selector Master del panel y elige:\n" +
              "Close " + compName + "\n\nLos grupos y controles permanecen intactos.");
    }

    // ------------------------------------------------------------
    // GESTOR DE GRUPOS LOGICOS
    // ------------------------------------------------------------
    var EGP_GROUPS = ["CONTROL", "TEXTO", "ANIMACION", "ELEMENTOS"];
    var selectedEGPGroup = 0;

    function sanitizeGroupName(name) {
        var s = String(name || "").replace(/^\s+|\s+$/g, "");
        return s || "GRUPO";
    }

    function groupLabel(groupName, elementLabel) {
        return sanitizeGroupName(groupName) + "  ›  " + elementLabel;
    }

    function addSelectedPropertiesToEGPGroup(groupName) {
        var comp = getActiveComp(); if (!comp) return;
        var props = comp.selectedProperties || [];
        if (!props.length) { alert("Selecciona una o mas propiedades en Timeline/Effect Controls."); return; }
        var added = 0, skipped = 0;
        app.beginUndoGroup(SCRIPT_NAME + " — Add Group");
        try {
            try { if (comp.openInEssentialGraphics) comp.openInEssentialGraphics(); } catch (e0) {}
            for (var i = 0; i < props.length; i++) {
                var p = props[i];
                var label = groupLabel(groupName, bestPropLabel(p));
                if (safeAdd(p, comp, label)) added++; else skipped++;
            }
        } finally { app.endUndoGroup(); }
        alert("GRUPO: " + groupName + "\n\nAgregadas: " + added +
              "\nOmitidas/no compatibles/ya existentes: " + skipped);
    }

    function groupManager() {
        var w = new Window("dialog", "JCMega EGP — Gestor de grupos", undefined, {resizeable:true});
        w.orientation = "column"; w.alignChildren = ["fill", "top"]; w.margins = 12; w.spacing = 8;

        var info = w.add("statictext", undefined, "Grupos logicos para organizar los controles que agrega el Builder.");
        info.alignment = "left";

        var list = w.add("listbox", undefined, [], {multiselect:false});
        list.preferredSize = [420, 180];

        function refresh() {
            list.removeAll();
            for (var i=0;i<EGP_GROUPS.length;i++) list.add("item", EGP_GROUPS[i]);
            if (EGP_GROUPS.length) {
                selectedEGPGroup = Math.max(0, Math.min(selectedEGPGroup, EGP_GROUPS.length-1));
                list.selection = selectedEGPGroup;
            }
        }
        refresh();

        var row = w.add("group"); row.orientation = "row"; row.alignChildren = ["fill","center"];
        var add = row.add("button", undefined, "+ Agregar grupo");
        var rename = row.add("button", undefined, "Renombrar");
        var remove = row.add("button", undefined, "Eliminar");

        var row2 = w.add("group"); row2.orientation = "row"; row2.alignChildren = ["fill","center"];
        var addSel = row2.add("button", undefined, "Agregar seleccion al grupo");
        var use = row2.add("button", undefined, "Usar grupo");

        var note = w.add("statictext", undefined,
            "Nota: estos grupos se aplican como prefijo de organizacion (GRUPO › ELEMENTO).\n" +
            "After Effects permite crear grupos reales desde Add Formatting > Add Group,\n" +
            "pero la API publica de ExtendScript no expone crear/mover esos grupos.", {multiline:true});
        note.alignment = "left";

        add.onClick = function() {
            var d = new Window("dialog", "Nuevo grupo"); d.orientation="column"; d.alignChildren=["fill","top"]; d.margins=10;
            d.add("statictext",undefined,"Nombre del grupo:");
            var f=d.add("edittext",undefined,"NUEVO GRUPO"); f.active=true;
            var r=d.add("group"); r.alignment="right"; r.add("button",undefined,"Cancelar",{name:"cancel"}); var ok=r.add("button",undefined,"Crear",{name:"ok"});
            ok.onClick=function(){var n=sanitizeGroupName(f.text); if(n){EGP_GROUPS.push(n); selectedEGPGroup=EGP_GROUPS.length-1; refresh(); d.close();}};
            d.center(); d.show();
        };

        rename.onClick = function() {
            if (!list.selection) return;
            var idx=list.selection.index;
            var d=new Window("dialog","Renombrar grupo"); d.orientation="column"; d.alignChildren=["fill","top"]; d.margins=10;
            d.add("statictext",undefined,"Nuevo nombre:");
            var f=d.add("edittext",undefined,EGP_GROUPS[idx]); f.active=true;
            var r=d.add("group"); r.alignment="right"; r.add("button",undefined,"Cancelar",{name:"cancel"}); var ok=r.add("button",undefined,"Guardar",{name:"ok"});
            ok.onClick=function(){EGP_GROUPS[idx]=sanitizeGroupName(f.text); selectedEGPGroup=idx; refresh(); d.close();};
            d.center(); d.show();
        };

        remove.onClick = function() {
            if (!list.selection) return;
            var idx=list.selection.index;
            if (!confirm("¿Eliminar el grupo '"+EGP_GROUPS[idx]+"'?\n\nEsto no elimina controles de Essential Graphics.")) return;
            EGP_GROUPS.splice(idx,1);
            selectedEGPGroup=Math.max(0,idx-1);
            refresh();
        };

        addSel.onClick = function() {
            if (!list.selection) { alert("Selecciona un grupo."); return; }
            selectedEGPGroup=list.selection.index;
            addSelectedPropertiesToEGPGroup(EGP_GROUPS[selectedEGPGroup]);
        };

        use.onClick = function() {
            if (!list.selection) { alert("Selecciona un grupo."); return; }
            selectedEGPGroup=list.selection.index;
            alert("Grupo activo: " + EGP_GROUPS[selectedEGPGroup]);
            w.close();
        };

        list.onChange=function(){if(list.selection) selectedEGPGroup=list.selection.index;};
        var close=w.add("button",undefined,"Cerrar",{name:"ok"}); close.alignment="right";
        close.onClick=function(){w.close();};
        w.center(); w.show();
    }

    function renameEGPControllersByElement() {
        var comp=getActiveComp(); if(!comp) return;
        var count=0;
        try{count=comp.motionGraphicsTemplateControllerCount;}
        catch(e){alert("AE no expone los controladores EGP en esta version.");return;}
        if(!count){alert("No hay controladores en Essential Graphics.");return;}
        if(typeof comp.setMotionGraphicsControllerName !== "function"){
            alert("Tu version de AE no permite renombrar controladores por script.");return;
        }
        var renamed=0;
        // Normaliza prefijos comunes (todo lo anterior al primer separador — o -).
        for(var i=1;i<=count;i++){
            try{
                var old=comp.getMotionGraphicsTemplateControllerName(i);
                var n=String(old).replace(/^.*?\s*[—-]\s*/,'');
                if(n && n!==old){comp.setMotionGraphicsControllerName(i,n);renamed++;}
            }catch(e2){}
        }
        alert("Controladores EGP revisados: "+count+"\nRenombrados: "+renamed);
    }

    // ------------------------------------------------------------
    // UI
    // ------------------------------------------------------------
    function buildUI(thisObj){
        var pal=(thisObj instanceof Panel)?thisObj:new Window("palette",SCRIPT_NAME,undefined,{resizeable:true});
        pal.orientation="column"; pal.alignChildren=["fill","top"]; pal.spacing=7; pal.margins=10;

        var title=pal.add("statictext",undefined,"JCMega EGP Auto Builder PRO v"+VERSION); title.alignment="center";
        var sub=pal.add("statictext",undefined,"Essential Graphics / MOGRT / Premiere Pro"); sub.alignment="center";

        var quick=pal.add("panel",undefined,"Herramientas rapidas"); quick.orientation="column"; quick.alignChildren=["fill","top"]; quick.margins=8;
        var bCloseEGP=quick.add("button",undefined,"✕  CERRAR COMPOSICION EN EGP"); bCloseEGP.preferredSize.height=34;
        var bAnalyze=quick.add("button",undefined,"Analizar composicion / EGP");
        var bAnalyzeSel=quick.add("button",undefined,"Analizar propiedades seleccionadas");
        var bAddSel=quick.add("button",undefined,"＋ Agregar propiedades seleccionadas");
        var bAuto=quick.add("button",undefined,"⚙ Crear controles + expresiones automaticas");
        var bRename=quick.add("button",undefined,"✎ Normalizar nombres EGP");
        var bGroups=quick.add("button",undefined,"▦ Gestionar grupos");

        var mode=pal.add("panel",undefined,"Destino"); mode.orientation="column"; mode.alignChildren=["left","top"]; mode.margins=8;
        var rbAll=mode.add("radiobutton",undefined,"Toda la composicion");
        var rbSelected=mode.add("radiobutton",undefined,"Solo capas seleccionadas"); rbAll.value=true;

        var p=pal.add("panel",undefined,"Builder inteligente"); p.orientation="column"; p.alignChildren=["left","top"]; p.margins=8;
        var cbSmart=p.add("checkbox",undefined,"Modo inteligente (recomendado)");cbSmart.value=true;
        var cbText=p.add("checkbox",undefined,"Texto de origen");cbText.value=true;
        var cbPos=p.add("checkbox",undefined,"Posicion");cbPos.value=true;
        var cbScale=p.add("checkbox",undefined,"Escala");cbScale.value=true;
        var cbRot=p.add("checkbox",undefined,"Rotacion");cbRot.value=true;
        var cbOpacity=p.add("checkbox",undefined,"Opacidad");cbOpacity.value=true;
        var cbFX=p.add("checkbox",undefined,"Controles de efectos");cbFX.value=true;
        var cbBlur=p.add("checkbox",undefined,"Solo efectos de desenfoque");cbBlur.value=true;

        var np=pal.add("panel",undefined,"Nombre del MOGRT"); np.orientation="row"; np.alignChildren=["fill","center"]; np.margins=7;
        var nameField=np.add("edittext",undefined,""); nameField.characters=26;
        var buildBtn=pal.add("button",undefined,"⚡ CREAR CONTROLES");buildBtn.preferredSize.height=34;
        var exportBtn=pal.add("button",undefined,"⬇ EXPORTAR .MOGRT");exportBtn.preferredSize.height=30;
        var openBtn=pal.add("button",undefined,"Abrir Graficos esenciales");

        bCloseEGP.onClick=closeCompInEGP;
        bAnalyze.onClick=analyzeComp;
        bAnalyzeSel.onClick=analyzeSelection;
        bAddSel.onClick=addSelectedPropertiesToEGP;
        bAuto.onClick=autoControlsFromSelection;
        bRename.onClick=renameEGPControllersByElement;
        bGroups.onClick=groupManager;
        buildBtn.onClick=function(){build({selectedOnly:rbSelected.value,smart:cbSmart.value,text:cbText.value,position:cbPos.value,scale:cbScale.value,rotation:cbRot.value,opacity:cbOpacity.value,effects:cbFX.value,onlyBlur:cbBlur.value,templateName:nameField.text});};
        exportBtn.onClick=function(){exportMogrt(nameField.text);};
        openBtn.onClick=function(){var c=getActiveComp();if(c&&c.openInEssentialGraphics)try{c.openInEssentialGraphics();}catch(e){}};

        pal.layout.layout(true); pal.onResizing=pal.onResize=function(){this.layout.resize();};
        if(pal instanceof Window){pal.center();pal.show();}
        return pal;
    }
    buildUI(thisObj);
})(this);
