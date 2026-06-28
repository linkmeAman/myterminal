# WezTerm Developer Cockpit: CLI Setup Guide

To achieve the ultimate IDE-like experience in your terminal, you need a modern CLI ecosystem. This guide provides commands to install and configure the necessary tools on Windows using `winget` or `scoop`.

## 1. Starship (The Cross-Shell Prompt)

Starship provides the dynamic context you requested (Git branch, K8s context, Docker context, Node/Python versions) asynchronously, so it never slows down your terminal.

**Install via Winget:**
```powershell
winget install --id Starship.Starship
```

Your `Microsoft.PowerShell_profile.ps1` is already configured to load it!

## 2. Native Terminal Enhancements (Already Configured)
The repository automatically configures the following native features without needing additional external downloads:
- **PSReadLine**: Enabled in your PowerShell profile for Fish-like predictive text (ghost text based on history) and syntax highlighting.
- **Acrylic Glass Background**: Enabled in `appearance.lua` to hook into Windows 11's compositor for a premium transparent blur effect.

## 3. Modern CLI Replacements

Replace legacy tools with their modern, Rust-based equivalents.

**eza** (Modern `ls` with icons and git integration)
```powershell
winget install --id eza-community.eza
```

**bat** (Modern `cat` with syntax highlighting and git diffs)
```powershell
winget install --id sharkdp.bat
```

**zoxide** (Smarter `cd` that remembers your directories)
```powershell
winget install --id ajeetdsouza.zoxide
```

**fzf** (Fuzzy finder for the terminal)
```powershell
winget install --id junegunn.fzf
```

## 3. Session Persistence (Zellij)

Since WezTerm doesn't inherently persist sessions across reboots natively, **Zellij** is the recommended multiplexer (it is essentially a modern, easier-to-use Tmux). It works phenomenally well inside WSL Ubuntu.

**Install inside WSL Ubuntu:**
```bash
wget -O zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
tar -xf zellij.tar.gz
sudo install zellij /usr/local/bin
```

**Copy the layouts from your repo into WSL:**
```bash
mkdir -p ~/.config/zellij/layouts
cp /mnt/d/myterminal/zellij/layouts/*.kdl ~/.config/zellij/layouts/
```

**Usage — Boot a full pre-wired workspace instantly:**
```bash
zellij --layout backend   # Server | Database | Git panes
zellij --layout ai        # Editor | Python REPL | Logs panes
zellij --layout devops    # Kubernetes | Docker | Monitor panes
```

> **Note**: Once Zellij is running, close WezTerm entirely. Reopen it and run `zellij attach` to
> restore every single pane exactly as you left it — servers still running!

## 4. TUI Tools (Optional but Recommended)

**lazygit** (A brilliant terminal UI for Git)
```powershell
winget install --id jesseduffield.lazygit
```

**yazi** (Blazing fast terminal file manager with image previews)
```powershell
winget install --id sxyazi.yazi
```

**btop** (Resource monitor)
```powershell
winget install --id aristocratos.btop
```

---

> [!TIP]
> After installing these tools, simply **restart WezTerm**. Your new PowerShell profile will automatically detect `starship`, `zoxide`, and others, and your terminal will come alive!
