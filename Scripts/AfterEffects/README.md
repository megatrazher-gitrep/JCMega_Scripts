# JCMega EGP Auto Builder PRO (After Effects)

ExtendScript (`.jsx`) para **After Effects CC 2019+** (algunas funciones requieren AE 2020/2022).
Automatiza la creacion de plantillas de Motion Graphics (**MOGRT**) desde el panel
**Essential Graphics (EGP)**.

> Nota: este script es para **After Effects**, no para REAPER. Se incluye en este
> repositorio como herramienta del ecosistema JCMega.

## Instalacion

1. Copia `JCMega_EGP_Auto_Builder_v4.jsx` a:
   - **Windows:** `Program Files\Adobe\Adobe After Effects <version>\Support Files\Scripts\ScriptUI Panels\`
   - **macOS:** `/Applications/Adobe After Effects <version>/Scripts/ScriptUI Panels/`
2. Reinicia After Effects.
3. Abre el panel desde **Window > JCMega_EGP_Auto_Builder_v4.jsx**.
4. Habilita **Preferences > Scripting & Expressions > Allow Scripts to Write Files and Access Network**
   (necesario para exportar el `.mogrt` y para el cierre automatico en Windows).

## Funciones

- **Builder inteligente**: detecta el tipo de capa (texto, control/null, imagen/footage,
  grafico) y agrega al EGP las propiedades adecuadas (posicion, escala, rotacion, opacidad,
  texto de origen y controles de efectos).
- **Agregar propiedades seleccionadas**: envia al EGP las propiedades seleccionadas con
  etiquetas legibles (`NombreCapa — Propiedad`).
- **Auto Controls**: crea Expression Controls (Slider, Angle, Point, 3D Point, Checkbox,
  Color, Dropdown) y los vincula por expresion a las propiedades que no se pueden agregar
  directamente al EGP.
- **Exportar `.mogrt`**: usa `exportAsMotionGraphicsTemplate()` para generar el archivo final.
- **Analizador** de composicion y de seleccion.
- **Normalizar nombres** de controladores EGP.
- **Gestor de grupos logicos** (prefijos `GRUPO › ELEMENTO`).
- **Cerrar composicion en EGP** mediante automatizacion de UI (solo Windows).

## Correcciones en la v4.1

- **Auto Controls reparado**: la version anterior perdia la referencia a la capa
  (recorria `parentProperty` sobre un objeto que no lo expone) y terminaba llamando a
  `addEffectControl` sobre un grupo sin `ADBE Effect Parade`, provocando un error. Ahora
  la capa se resuelve con `property.propertyGroup(property.propertyDepth)`.
- **Tipos de propiedad correctos**: `PropertyValueType.ANGLE` no existe en After Effects;
  se mapean correctamente `OneD`, `TwoD`/`TwoD_SPATIAL`, `ThreeD`/`ThreeD_SPATIAL` y `COLOR`,
  y se soportan propiedades 3D con un 3D Point Control (con fallback a Point 2D en versiones
  antiguas).
- **Sin crashes en camaras/luces**: `addEffectControl` verifica que la capa admita efectos.
- **Etiquetas EGP mejores**: siempre usan el nombre real de la capa.
- **Nuevo: exportar `.mogrt`** para completar el objetivo del script.
- **Comprobaciones de version/plataforma** mas robustas (export y cierre en Windows).

## Referencia sobre la API de Adobe

Adobe expone `openInEssentialGraphics()`, el conteo/nombres de controladores EGP,
`exportAsMotionGraphicsTemplate()` y la API para agregar/renombrar, pero **no** expone un
`closeInEssentialGraphics()` publico. Por eso el cierre de la composicion en el panel EGP
se intenta mediante automatizacion de teclado (solo Windows) o de forma manual con el
selector *Master* del panel.
