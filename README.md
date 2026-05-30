# JCMega Scripts

<<<<<<< HEAD
Professional REAPER workflow tools created with ReaImGui.

These scripts are designed to improve speed, organization, and workflow efficiency inside REAPER with modern custom interfaces and advanced utility systems.

---

# Included Scripts

## JCMega HandScroll

A custom hand-scroll and zoom controller for REAPER built with ReaImGui and JS_ReaScriptAPI.

This script creates an interactive touchpad-style interface that allows smooth timeline scrolling and zooming directly inside REAPER.

### Features

* Hand-scroll style navigation
* Horizontal timeline scrolling
* Vertical track scrolling
* Mouse wheel zoom
* Selectable drag button:

  * Left Click
  * Right Click
  * Mouse Wheel Click
* Modern custom ImGui interface
* Visual drag feedback
* Lightweight and responsive

---

## JCMega Snapshot Manager

An advanced snapshot management system for REAPER that allows saving and restoring complete mix states instantly.

This script captures track settings such as:

* Volume
* Pan
* Mute state
* Solo state
* FX enabled/disabled states

Snapshots are stored directly inside the REAPER project using Project ExtState, allowing persistent recall between sessions.

### Features

* Save unlimited mix snapshots
* Instant snapshot recall
* Replace existing snapshots
* Delete snapshots with confirmation
* Reorder snapshots
* Active snapshot indicator
* Snapshot persistence inside project files
* Track state restoration by GUID
* FX enabled state recall
* Custom modern ImGui interface
* Status notification system
* Clipboard copy support

### Typical Uses

* Compare mix versions instantly
* A/B test processing chains
* Store alternative mastering setups
* Save arrangement states
* Create safety backups during mixing
* Fast client revision workflow

---

# Requirements

Before using these scripts, install:

* REAPER
* ReaImGui
* JS_ReaScriptAPI

Recommended installation method:

Use ReaPack inside REAPER.

---

# Installation

## 1. Install Dependencies

Install:

* ReaImGui
* JS_ReaScriptAPI

---

## 2. Add Scripts

Place the LUA scripts inside your REAPER Scripts folder.

Example:

```text
REAPER/Scripts/
```

---

## 3. Load Scripts in REAPER

1. Open:

   * Actions → Show Action List

2. Click:

   * ReaScript → Load

3. Select the desired script.

4. Run the script.

---

# Included LUA Files

```text
JCMega_HandScroll.lua
JCMega_SnapshotManager.lua
```

---

# Screenshots

Add interface screenshots inside the Screenshots folder.

Example:

```text
Screenshots/
```

---

# Author

Created by JC / MegaTrazher

---

# License

Free to use and modify.
=======
Professional REAPER tools and workflow enhancements developed by JC MediaFX.

## About

JCMega Scripts is a collection of Lua and ReaImGui scripts designed to improve productivity, workflow, mixing, routing, project organization, and customization inside REAPER.

The repository includes tools focused on:

- Workflow optimization
- Track management
- Mixer utilities
- Audio production tools
- Channel strips
- FX chain builders
- Theme and UI enhancements
- ReaImGui interfaces
- Content creator tools

---

## Requirements

Some scripts may require:

- REAPER 7+
- ReaImGui
- ReaPack
- SWS Extension

Recommended:

- Latest version of REAPER
- Latest version of ReaImGui
- Latest version of SWS

---

## Installation via ReaPack

1. Install ReaPack.

2. Open:

Extensions → ReaPack → Import repositories

3. Add the repository index:

```text
https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml
```

4. Synchronize packages.

5. Install the desired scripts.

---

## Categories

### Utilities

Workflow and productivity tools.

### Track Management

Tools for organizing and managing tracks.

### Mixer Tools

Mixing and routing utilities.

### Channel Strips

Channel strip style processing interfaces.

### Audio Tools

Audio analysis, gain staging, and workflow helpers.

### Theme Tools

Theme customization and interface enhancement tools.

### Rendering Tools

Render and export workflow utilities.

### FX Builders

Custom FX chain and processing builders.

### ReaImGui Tools

Advanced graphical interfaces built with ReaImGui.

---

## Development Status

This repository is under active development.

New tools, workflow enhancements, and professional versions are added regularly.

---

## Support the Project

If you enjoy these tools and want to support future development, follow:

### TikTok

https://www.tiktok.com/@megatrazher

### GitHub

https://github.com/megatrazher-gitrep

---

## Upcoming Features

- Advanced Channel Strips
- Track Templates Manager
- FX Chain Constructor PRO
- Theme Customization Tools
- Project Management Utilities
- Rendering Assistant
- Mixer Workflow Suite
- Audio Analysis Toolkit

---

## Contributing

Suggestions, feedback, and bug reports are always welcome.

You can open an issue in the GitHub repository to report bugs or request new features.

---

## License

MIT License

Copyright (c) JC MediaFX

---

## Author

JC MediaFX

Developed for the REAPER community with a focus on speed, usability, and professional workflows.
>>>>>>> ca6f0ff19ef14c89d83287cf5a121343e68e6620
