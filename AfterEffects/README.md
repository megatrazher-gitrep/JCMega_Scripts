# JCMega Render Segments (After Effects)

Herramienta de **render por segmentos** para Adobe After Effects, inspirada en el
flujo de *Render Segments* de aescripts.

Divide el render de una composición en **N segmentos por rango de fotogramas** y
los procesa de una de dos formas, para después **unirlos** automáticamente:

1. **Cola de After Effects (secuencial):** añade un ítem de render por segmento a
   la cola de AE. No requiere nada externo, pero no acelera el render (AE
   renderiza los ítems de uno en uno).
2. **Paralelo con `aerender` (recomendado):** lanza **una instancia de `aerender`
   por segmento en segundo plano**. Como After Effects aprovecha mal los múltiples
   núcleos dentro de un solo proceso, ejecutar varias instancias a la vez **satura
   la CPU y reduce drásticamente el tiempo de render** de proyectos largos. Al
   terminar, une los segmentos de vídeo con **ffmpeg** (concat, sin recodificar).

> ⚠️ **Nota:** esta es una herramienta para **After Effects (ExtendScript / `.jsx`)**.
> El resto del repositorio son scripts de **REAPER (Lua)**; viven en carpetas
> separadas y no comparten dependencias.

---

## Por qué acelera el render

Un único proceso de After Effects no escala bien a muchos núcleos. Al partir la
composición en tramos independientes y lanzar varias instancias de `aerender` en
paralelo, cada instancia trabaja sobre su propio rango de fotogramas y el sistema
operativo reparte la carga entre todos los núcleos disponibles. En equipos con
CPU de muchos núcleos y RAM suficiente, esto puede acercarse a una mejora lineal
con el número de instancias, hasta el límite de RAM/E-S del disco.

Ventaja adicional: si un segmento falla, **solo se vuelve a renderizar ese
segmento**, no toda la composición.

---

## Requisitos

| Modo | Requisitos |
|---|---|
| Cola de AE (secuencial) | Solo After Effects. |
| Paralelo (`aerender`) | After Effects con `aerender` (incluido en instalaciones estándar). |
| Unión de vídeo | [`ffmpeg`](https://ffmpeg.org/) instalado en el sistema. |

- After Effects CC (probado con CS6 y posteriores).
- Windows o macOS.
- Para renders `.mov` / `.mp4`, `ffmpeg` para la unión. Las **secuencias de
  imágenes** (PNG, EXR, TIFF…) **no necesitan unión**: cada instancia escribe
  fotogramas de distinto número en la misma secuencia continua.

---

## Instalación

### Opción A — Panel acoplable (recomendado)

1. Copia `JCMega_RenderSegments.jsx` a la carpeta **ScriptUI Panels** de After Effects:
   - **Windows:** `C:\Program Files\Adobe\Adobe After Effects <versión>\Support Files\Scripts\ScriptUI Panels\`
   - **macOS:** `/Applications/Adobe After Effects <versión>/Scripts/ScriptUI Panels/`
2. Reinicia After Effects.
3. Ábrelo desde el menú **Window > JCMega_RenderSegments.jsx**. Se puede acoplar
   como cualquier panel.

> Para permitir la ejecución de scripts, activa
> **Edit/After Effects > Preferences > Scripting & Expressions >
> "Allow Scripts to Write Files and Access Network"** (necesario para lanzar
> `aerender`/`ffmpeg` y escribir los scripts lanzadores).

### Opción B — Ejecución puntual

1. `File > Scripts > Run Script File...`
2. Selecciona `JCMega_RenderSegments.jsx`. Se abre como ventana flotante.

---

## Uso

1. **Guarda tu proyecto** (`.aep`). El modo paralelo necesita un proyecto en disco.
2. Activa o selecciona la **composición** a renderizar.
3. Pulsa **"Actualizar desde comp"** para leer la comp y sus plantillas.
4. Configura:
   - **Número de segmentos** (una buena base: el número de núcleos físicos).
   - **Solo área de trabajo** si solo quieres renderizar el *work area*.
   - **Render Settings** y **Output Module** (plantillas ya existentes en AE).
   - **Archivo de salida** base, p. ej. `D:\renders\shot.mov`. Cada segmento de
     vídeo se guarda como `shot_seg001.mov`, `shot_seg002.mov`, …
   - **Unir segmentos con ffmpeg** para obtener un único archivo final.
   - Rutas de **`aerender`** (autodetectada) y **`ffmpeg`**.
5. Acciones:
   - **Añadir a la cola de AE** → crea los ítems en la cola (render secuencial).
   - **Renderizar en paralelo** → guarda una copia del proyecto, genera el script
     lanzador y arranca todas las instancias de `aerender` en segundo plano; al
     terminar, une el vídeo con ffmpeg.
   - **Generar scripts (sin lanzar)** → escribe el proyecto copia y el lanzador
     (`.bat` / `.command`) para revisarlos o ejecutarlos manualmente.

Todos los archivos generados (copia del proyecto, script lanzador, lista de
concatenación y marcadores `.done`) se crean en una subcarpeta
`JCMega_RenderSegments` junto al archivo de salida.

---

## Cómo funciona por dentro

- **Reparto de fotogramas:** el rango total `[inicio … fin]` se divide en tramos
  contiguos e **inclusivos**; el resto de la división se reparte entre los
  primeros segmentos, de modo que **no se pierde ni se duplica ningún fotograma**.
- **`aerender`:** cada segmento se invoca con
  `aerender -project <copia.aep> -comp <nombre> -s <inicio> -e <fin> -RStemplate … -OMtemplate … -output <archivo>`.
- **Lanzador paralelo:**
  - *Windows* (`run_segments.bat`): lanza cada segmento con `start /min`
    (paralelo), espera mediante marcadores `.done` y luego ejecuta ffmpeg.
  - *macOS* (`run_segments.command`): lanza cada segmento con `&`, hace `wait` y
    luego ejecuta ffmpeg.
- **Unión:** ffmpeg con el *demuxer* `concat` y `-c copy` (sin recodificar, sin
  pérdida ni tiempo extra), siempre que todos los segmentos compartan códec y
  parámetros (lo cual garantiza el mismo Output Module).

### Fotograma final `-e` (inclusivo / exclusivo)

El significado exacto del flag `-e` de `aerender` ha variado entre versiones de
After Effects. Por defecto se trata como **inclusivo**. Si observas un fotograma
**duplicado o faltante** en los límites entre segmentos, activa la casilla
**"Tratar -e como fotograma final EXCLUSIVO"** y vuelve a renderizar.

---

## Consejos de rendimiento

- Empieza con **tantos segmentos como núcleos físicos**; ajusta según la RAM.
- Cada instancia de `aerender` consume RAM independiente: vigila el uso total.
- Discos rápidos (SSD/NVMe) ayudan cuando muchas instancias escriben a la vez.
- Para máxima velocidad y flexibilidad, exporta a **secuencia de imágenes** y
  únela después: evitas por completo el paso de concatenación de vídeo.

---

## Limitaciones conocidas

- El progreso de las instancias en segundo plano no se muestra dentro de AE; se
  consulta en la carpeta de salida o en la ventana de consola del lanzador.
- La unión con `-c copy` requiere que todos los segmentos usen el mismo códec y
  parámetros (se cumple al compartir Output Module). Para códecs intra-frame como
  ProRes/DNxHR es lo ideal; para formatos con GOP largo, revisa el resultado.
- Probado conceptualmente contra la API de scripting de After Effects; valida en
  tu versión concreta antes de usarlo en producción.

---

## Autor

Creado por **JC MediaFX / MegaTrazher**.
