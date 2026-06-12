# JCMega_Scripts

Professional workflow tools for **REAPER**, created by **JC / MegaTrazher**.

This repository contains Lua scripts focused on improving speed, organization, navigation, visual workflow, project setup, and session management inside REAPER.

---

## ReaPack Repository Link

Use this link to import the repository in ReaPack:

```text
https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml
```

Direct link:

[Import JCMega Scripts in ReaPack](https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml)

---

## Available Scripts

| Script | File | Description |
|---|---|---|
| **JCMega GradienTracks** | `Scripts/JCMega_GradienTracks.lua` | Applies gradient-style track coloring to improve visual organization and make track groups easier to identify. |
| **JCMega Hand Scroll** | `Scripts/JCMega_Hand Scroll.lua` | Adds a hand-scroll style navigation pad for moving through the REAPER arrange view more comfortably. |
| **JCMega Snapshot Manager** | `Scripts/JCMega_Snapshot Manager.lua` | Saves, loads, replaces, deletes, and reorders project snapshots for faster mix/session recall. |
| **JCMega Template Constructor** | `Scripts/JCMega_Template Constructor.lua` | Helps build reusable REAPER templates and speed up project setup workflows. |
| **JCMega Theme Switcher** | `Scripts/JCMega_Theme Switcher.lua` | Lets you browse and switch REAPER themes quickly from a dedicated interface. |

---

## Requirements

- **REAPER**
- **ReaPack**
- **ReaImGui**
- **JS_ReaScriptAPI** recommended for scripts that use advanced window, mouse, or interface control.

Install dependencies through ReaPack before running the scripts.

---

## Installation

### Option 1: ReaPack

1. Open **REAPER**.
2. Go to **Extensions > ReaPack > Import repositories...**
3. Copy and paste this repository URL:

```text
https://raw.githubusercontent.com/megatrazher-gitrep/JCMega_Scripts/main/index.xml
```

4. Click **OK**.
5. Go to **Extensions > ReaPack > Synchronize packages**.
6. Search for **JCMega** in the ReaPack package browser.
7. Install the scripts you want to use.

### Option 2: Manual Installation

1. Download or clone this repository.
2. Copy the `.lua` scripts into your REAPER scripts folder.
3. In REAPER, open **Actions > Show action list**.
4. Click **New Action > Load ReaScript**.
5. Select the script you want to add.
6. Run it from the Actions list or assign it to a shortcut, toolbar button, or menu.

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

A visual organization tool designed to color REAPER tracks using gradient-based logic. Useful for large sessions, track groups, buses, folders, and template organization.

### JCMega Hand Scroll

A navigation utility for moving around the REAPER arrange view with a more visual and direct scrolling workflow. Designed to make timeline navigation faster and more comfortable.

### JCMega Snapshot Manager

A session recall tool for saving and restoring project states. It is useful for comparing mix versions, testing ideas, storing temporary configurations, and quickly returning to previous states.

### JCMega Template Constructor

A project-building utility designed to speed up template creation and session setup. Useful for producers, editors, streamers, and REAPER users who work with repeated project structures.

### JCMega Theme Switcher

A theme management tool that allows fast switching between installed REAPER themes. Useful for testing layouts, changing visual environments, or quickly comparing custom themes.

---

## Recommended Use

These scripts are designed for users who want to build a faster, more visual, and more organized REAPER workflow.

They are especially useful for:

- Music production
- Mixing sessions
- Live streaming setups
- Template-based workflows
- Custom REAPER configurations
- Fast navigation and session management

---

## Author

Created by **JC / MegaTrazher**.

Repository: [JCMega_Scripts](https://github.com/megatrazher-gitrep/JCMega_Scripts)

---

## Status

This repository is actively being developed. More tools, improvements, and UI refinements may be added over time.
