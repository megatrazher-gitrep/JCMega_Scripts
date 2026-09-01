# Changelog

All notable changes to this project will be documented in this file.

---

# Unreleased

## Added

### JCMega Render Segments (After Effects)
- ExtendScript (`.jsx`) dockable ScriptUI panel for After Effects
- Splits a composition render into N frame-range segments (no lost/duplicated frames)
- Sequential mode: adds one render-queue item per segment
- Parallel mode: launches one background `aerender` instance per segment for multi-core speedup
- Optional lossless join of video segments with ffmpeg (`concat` demuxer, `-c copy`)
- Image-sequence aware (skips per-segment suffix and join for numbered sequences)
- Render Settings / Output Module template pickers read from the active comp
- Work-area-only rendering option
- Auto-detection of `aerender`, configurable ffmpeg path
- Adjustable inclusive/exclusive `-e` end-frame handling
- Persistent preferences via `app.settings`
- Cross-platform launcher generation (Windows `.bat` / macOS `.command`)

---

# v1.0

## Added

### JCMega HandScroll
- Hand-scroll style navigation system
- Horizontal timeline scrolling
- Vertical track scrolling
- Mouse wheel zoom support
- Selectable drag button modes
- Modern ReaImGui interface
- Smooth navigation workflow
- Visual drag feedback system

---

### JCMega Snapshot Manager
- Snapshot save system
- Snapshot recall system
- Snapshot replace function
- Snapshot delete confirmation
- Snapshot reordering
- Active snapshot indicator
- Track state capture:
  - Volume
  - Pan
  - Mute
  - Solo
  - FX enabled states
- Persistent project storage using ExtState
- Track restoration by GUID
- Clipboard copy support
- Status notification system
- Custom ReaImGui interface
- Snapshot management workflow

---

## Requirements
- REAPER
- ReaImGui
- JS_ReaScriptAPI

---

## Initial Release
First public release of the JCMega Scripts collection.