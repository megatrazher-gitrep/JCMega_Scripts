# JCMega_Scripts

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
