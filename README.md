# JCMega Scripts

Professional workflow tools for **REAPER**, created by **JC / MegaTrazher**.

This repository contains Lua scripts designed to improve workflow speed, visual organization, navigation, project setup, theme switching, and session management inside REAPER.

---

## ReaPack Repository

Use this URL to import the repository in ReaPack:

```text
https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml
```

Direct link:

[Open ReaPack index.xml](https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml)

---

## Installation with ReaPack

1. Open **REAPER**.
2. Go to **Extensions > ReaPack > Import repositories...**
3. Paste this URL:

```text
https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml
```

4. Click **OK**.
5. Go to **Extensions > ReaPack > Synchronize packages**.
6. Search for **JCMega**.
7. Install the scripts you want to use.

> If ReaPack shows an obsolete package warning after updating the repository, choose **Ignore** and synchronize again after the updated `index.xml` has been uploaded.

---

## Available Scripts

| Script | File | Description |
|---|---|---|
| **JCMega GradienTracks** | `Scripts/JCMega_GradienTracks.lua` | Applies gradient-style coloring to REAPER tracks for faster visual organization. Useful for folders, buses, groups, and large sessions. |
| **JCMega Hand Scroll** | `Scripts/JCMega_Hand Scroll.lua` | Adds a hand-scroll style navigation workflow for moving through the REAPER arrange view more comfortably. |
| **JCMega Snapshot Manager** | `Scripts/JCMega_Snapshot Manager.lua` | Saves, loads, replaces, deletes, and reorders project snapshots for fast mix/session recall. |
| **JCMega Template Constructor** | `Scripts/JCMega_Template Constructor.lua` | Helps build reusable REAPER templates and speed up project setup workflows. |
| **JCMega Theme Switcher** | `Scripts/JCMega_Theme Switcher.lua` | Lets you browse and switch REAPER themes quickly from a dedicated workflow. |

---

## After Effects Tools

In addition to the REAPER scripts, this repository includes tools for **Adobe After Effects** (ExtendScript `.jsx`).

| Tool | File | Description |
|---|---|---|
| **JCMega Render Segments** | `AfterEffects/JCMega_RenderSegments.jsx` | Splits a composition render into N frame-range segments and renders them in parallel using multiple background `aerender` instances (multi-core speedup), then optionally joins the video segments with ffmpeg. Inspired by the *Render Segments* workflow. |

See [`AfterEffects/README.md`](AfterEffects/README.md) for installation and usage.

---

## Featured Script: JCMega GradienTracks

**JCMega GradienTracks** is a visual organization tool for REAPER that helps color tracks using gradient-style logic.

It is designed to make sessions easier to read, especially when working with:

- Large track counts
- Folder structures
- Buses and submixes
- Mix templates
- Color-coded production workflows
- Streaming or live session templates

---

## Requirements

- **REAPER**
- **ReaPack**
- **ReaImGui**
- **JS_ReaScriptAPI** recommended for scripts that use advanced window, mouse, or interface control.

Install dependencies through ReaPack before running the scripts.

---

## Manual Installation

1. Download or clone this repository.
2. Copy the `.lua` files from the `Scripts` folder.
3. Open REAPER.
4. Go to **Actions > Show action list**.
5. Click **New Action > Load ReaScript**.
6. Select the script you want to add.
7. Run it from the Actions list or assign it to a shortcut, toolbar button, or menu.

---

## Repository Structure

```text
JCMega_Scripts/
│
├── Scripts/
│   ├── JCMega_GradienTracks.lua
│   ├── JCMega_Hand Scroll.lua
│   ├── JCMega_Snapshot Manager.lua
│   ├── JCMega_Template Constructor.lua
│   └── JCMega_Theme Switcher.lua
│
├── .github/
│   └── workflows/
│
├── index.xml
└── README.md
```

---

## Script Overview

### JCMega GradienTracks

A gradient-based track coloring tool for improving visual organization in REAPER projects.

### JCMega Hand Scroll

A navigation utility for moving around the arrange view with a more direct and comfortable scrolling workflow.

### JCMega Snapshot Manager

A session recall tool for saving and restoring project states. Useful for comparing mix versions, testing ideas, and returning to previous configurations.

### JCMega Template Constructor

A project-building utility designed to speed up template creation and repeated session setup.

### JCMega Theme Switcher

A theme management tool that allows fast switching between installed REAPER themes.

---

## Recommended Use

These scripts are useful for:

- Music production
- Mixing sessions
- Editing workflows
- Live streaming setups
- Template-based workflows
- Custom REAPER configurations
- Fast navigation and session management

---

## Author

Created by **JC / MegaTrazher**.

Repository:

[JCMega_Scripts](https://github.com/megatrazher-gitrep/JCMega_Scripts)

---

## Status

This repository is actively being developed. More tools, improvements, and UI refinements may be added over time.
