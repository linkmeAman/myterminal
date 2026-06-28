# WezTerm Developer Cockpit

A production-grade, highly modular WezTerm configuration designed for Backend, DevOps, and AI engineers.

## 🗺️ Anatomy of the Terminal (UI Lookup)

Here is a visual breakdown of your new terminal interface:

```text
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │  󰇄  D:\myterminal     1: nvim █   2: server   3: database     [LEADER] 14:32 │
 │──────────────────────────────────────────────────────────────────────────────│
 │ ~                                                                            │
 │ ❯ npm run start                                                              │
 │                                                                              │
 │ 🚀 Server starting on http://localhost:3000                                  │
 │                                                                              │
 │                                                                              │
 ╰──────────────────────────────────────────────────────────────────────────────╯
```

### UI Legend
- **` 󰇄 D:\myterminal `** *(Top Left)*: Your active WezTerm workspace (managed by the Smart Sessionizer).
- **` 1: nvim █ `** *(Top Center)*: Your clean, inline tabs. The active tab is highlighted in lavender.
- **` [LEADER] `** *(Top Right)*: A dynamic red badge that **only appears** when you press `Ctrl+Space`, letting you know it's listening for shortcuts.
- **` 14:32 `** *(Far Right)*: The current system time.
- **` ~ ❯ `** *(Main Window)*: Your multi-line **Starship** prompt, which gives you clean typing space away from your folder path.

---

## Architecture & Features

### 1. Structural Changes (Hot Reload & Easy Management)
- **Modular Directory Setup**: Configuration files are broken down into a dedicated directory (`D:\myterminal`) instead of a massive single file.
- **Proxy Link**: Your home directory (`C:\Users\amans\.wezterm.lua`) acts as a simple proxy pointer referencing the main directory, isolating appearance, keybindings, and workspaces.
- **Automatic Hot Reloading**: Saving any sub-module instantly updates the UI without a terminal restart.

### 2. Multiplexer Additions (Tab & Pane Management)
- **Native Workspace Engine**: Pre-configured layouts (Backend, AI, DevOps) allow you to jump between distinct project environments using the fuzzy finder (`Leader + w`).
- **Session Persistence**: Built-in support for Tmux-like window management, with Zellij compatibility designed for persistent WSL sessions.

### 3. Modern TUI & CLI Upgrades (Visual Flavor & Ease of Use)
- **Starship**: Cross-shell prompt that dynamically displays context like active Git branches and container environments.
- **PSReadLine**: Fish-like predictive text and syntax highlighting for PowerShell.
- **Interactive TUIs**: Ready for `lazygit` (Git management), `yazi` (file explorer with image previews), and `btop` (graphical system monitor).
- **Smart Command Replacements**: Aliased integrations for `eza` (icons & metadata), `bat` (syntax highlighted viewing), and `zoxide` / `fzf` (fuzzy directory jumping).

## Installation (Windows)

This repository comes with a fully automated, one-command setup script.

1. Clone this repository anywhere on your PC (e.g. `D:\myterminal`).
2. Open Windows PowerShell, navigate to the folder, and run the installer:

```powershell
cd D:\myterminal
.\install.ps1
```

**That's it.** The script will automatically:
- Link WezTerm to this configuration directory.
- Download and install the JetBrainsMono Nerd Fonts.
- Boot into WSL and install all CLI utilities, editors (LazyVim), and multiplexers (Zellij).
- Deploy all your custom dotfiles into WSL.

*Note: You must completely close and reopen WezTerm for the font changes to take effect.*

## Installation (Mac / Linux)

1. Clone this repository to `~/.config/wezterm` (or symlink it).
2. WezTerm will natively detect and load `~/.config/wezterm/wezterm.lua`. No proxy file is needed.

## Keybindings (Leader: `Ctrl + Space`)

- **Command Palette (List all commands)**: `Leader + Shift + P`
- **Show Key Assignments**: `Leader + Shift + ?`
- **New Tab**: `Leader + c`
- **Navigate Tabs**: `Leader + n` (next), `Leader + p` (prev)
- **Select Tab (1-9)**: `Leader + 1-9`
- **Fuzzy Find Workspaces**: `Leader + w`
- **Create Custom Workspace**: `Leader + Shift + w`
- **Smart Sessionizer Plugin**: `Leader + s` (Fuzzy-find Zoxide projects)
- **Resize Mode**: `Leader + r` (Tap arrow keys to resize, Esc to lock)
- **Split Horizontal**: `Leader + Shift + |`
- **Split Vertical**: `Leader + -`
- **Search Terminal**: `Leader + /`
- **Copy Mode (Vim)**: `Leader + [`
- **Quick Select**: `Leader + Space`
- **Zoom Pane**: `Leader + z`
- **Copy**: `Ctrl + Shift + C` (or just highlight text)
- **Paste**: `Ctrl + Shift + V` (or Right-Click)
- **Quit Application**: `Leader + q`
- **View All Shortcuts**: `Leader + ?`

---

## Daily Workflow & Cheat Sheet

Your terminal is supercharged with several modern Rust-based utilities. Here is how to use them:

### 🚀 Smarter Navigation (`zoxide`)
`zoxide` replaces `cd` and learns the directories you visit.
1. **Train it:** Visit a directory normally once (`cd D:\myterminal`).
2. **Teleport:** From anywhere else, simply type `z term` or `z myterminal` to instantly jump back.

### 📁 Modern File Exploration (`eza` & `yazi`)
- **`ls`**: Runs `eza` under the hood. Displays beautifully colored files with actual icons (JavaScript logos, Rust gears, etc.).
- **`yazi`**: Type this to open a blazing-fast, visual file manager directly in your terminal pane. Use arrow keys to browse, `Enter` to open, and `q` to quit.

### 📝 Better File Viewing (`bat`)
- **`cat filename.txt`**: Runs `bat` under the hood. Instead of dumping plain text, it prints your file with a beautiful border, line numbers, and full syntax highlighting.

### 🐙 Git Management (`lazygit`)
- **`lazygit`**: Navigate to any Git repository and type this command. It opens a massive interactive UI to commit, push, pull, and manage branches without ever typing a single verbose git command. Press `q` to quit.

### ⌨️ Predictive Typing (`PSReadLine`)
Your PowerShell is configured with Fish-like predictive IntelliSense. 
- As you type, you will see gray "ghost" text suggesting the rest of your command based on your history.
- Simply press the **`Right Arrow`** key to instantly autocomplete the suggestion!
