# JCMega Scripts

Professional REAPER tools and workflow enhancements developed by JC MediaFX.

JCMega Scripts is a collection of Lua and ReaImGui scripts designed to improve productivity, workflow, mixing, routing, project organization, and customization inside REAPER.

---

## ReaPack Repository

Add the following repository to ReaPack:

```text
https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml
```

### Installation via ReaPack

1. Install ReaPack.
2. Open REAPER.
3. Go to:

```text
Extensions → ReaPack → Import repositories
```

4. Click **Add**.
5. Paste the repository URL above.
6. Synchronize packages.
7. Install the desired JCMega Scripts packages.

---

## About

The repository includes tools focused on:

* Workflow optimization
* Track management
* Mixer utilities
* Audio production tools
* Channel strips
* FX chain builders
* Theme and UI enhancements
* ReaImGui interfaces
* Content creator tools

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
* Selectable drag button

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

## JCMega Template Constructor

A powerful template creation and management system for REAPER designed to build complete track templates quickly and consistently.

The Template Constructor allows users to create reusable project building blocks, speeding up session setup and maintaining standardized workflows across productions.

### Features

* Create track templates from existing tracks
* Save custom template collections
* Organize templates by category
* One-click template loading
* Custom ReaImGui interface
* Fast project setup workflow
* Template preview system
* Track color and icon support
* Routing and FX preservation
* Professional workflow optimization

### Typical Uses

* Recording session templates
* Mixing templates
* Mastering chains
* Live streaming setups
* Podcast production templates
* Content creator workflows

---

## JCMega Theme Switcher

A modern theme management utility for REAPER that allows users to quickly switch, organize, and manage installed themes from a single interface.

Built with ReaImGui, Theme Switcher provides a faster and more visual workflow for theme selection without navigating through multiple REAPER menus.

### Features

* Instant theme switching
* Installed theme browser
* Theme organization tools
* Favorite themes system
* Search and filtering
* Modern ReaImGui interface
* Fast theme preview workflow
* Lightweight and responsive
* One-click theme loading
* Workflow-focused design

### Typical Uses

* Quickly switch between workspaces
* Organize large theme collections
* Create dedicated mixing environments
* Create dedicated editing environments
* Improve visual workflow efficiency
* Customize REAPER appearance instantly

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

## Requirements

Some scripts may require:

* REAPER 7+
* ReaImGui
* ReaPack
* JS_ReaScriptAPI
* SWS Extension

### Recommended

* Latest version of REAPER
* Latest version of ReaImGui
* Latest version of SWS

---

## Included LUA Files

```text
JCMega_HandScroll.lua
JCMega_SnapshotManager.lua
JCMega_TemplateConstructor.lua
JCMega_ThemeSwitcher.lua
```

---

## Development Status

This repository is under active development.

New tools, workflow enhancements, and professional versions are added regularly.

---

## Upcoming Features

* Advanced Channel Strips
* FX Chain Constructor PRO
* Project Management Utilities
* Rendering Assistant
* Mixer Workflow Suite
* Audio Analysis Toolkit
* Track Management Suite
* Workflow Automation Tools

---

## Support the Project

If you enjoy these tools and want to support future development, follow:

### TikTok

https://www.tiktok.com/@megatrazher

### GitHub

https://github.com/megatrazher-gitrep

Professional and commercial PRO versions of selected tools are currently in development.

---

## Contributing

Suggestions, feedback, feature requests, and bug reports are always welcome.

You can open an issue in the GitHub repository to report bugs or request new features.

---

## License

MIT License

Copyright (c) JC MediaFX

---

## Author

JC MediaFX

Developed for the REAPER community with a focus on speed, usability, professional workflows, and modern user interface design.
