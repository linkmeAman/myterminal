local wezterm = require 'wezterm'
local act = wezterm.action
local helpers = require 'utils.helpers'

return function(config)
    -- Leader Key (Tmux Style)
    config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }

    -- Shell integration
    if helpers.is_windows then
        -- WSL Domain Integration: make Ubuntu the primary shell
        config.wsl_domains = {
            {
                name = "WSL:Ubuntu",
                distribution = "Ubuntu",
                username = "root",
                default_cwd = "~",
            },
        }
        config.default_domain = "WSL:Ubuntu"
        config.launch_menu = {
            { label = "  WSL Ubuntu (Default)", args = { "wsl.exe", "-d", "Ubuntu" } },
            { label = "  PowerShell 7",        args = { "pwsh.exe", "-NoLogo" } },
            { label = "  Windows PowerShell",  args = { "powershell.exe", "-NoLogo" } },
            { label = "  Git Bash",            args = { "C:\\Program Files\\Git\\bin\\bash.exe" } },
            { label = "  Command Prompt",      args = { "cmd.exe" } },
        }
    else
        config.default_prog = { "zsh" }
    end

    config.keys = {
        -- Launch Menu / Command Palette
        { key = "P", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },
        { key = "?", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs { flags = "FUZZY|KEY_ASSIGNMENTS" } },
        { key = "l", mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|LAUNCH_MENU_ITEMS" } },

        -- Workspaces (Built-in)
        { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
        { key = "W", mods = "LEADER|SHIFT", action = act.PromptInputLine {
            description = wezterm.format { { Attribute = { Intensity = 'Bold' } }, { Text = 'Enter workspace name: ' } },
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(act.SwitchToWorkspace { name = line }, pane)
                end
            end),
        } },

        -- Tabs
        { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
        { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
        { key = "x", mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
        { key = "X", mods = "LEADER|SHIFT", action = act.CloseCurrentTab { confirm = true } },
        { key = "q", mods = "LEADER", action = act.QuitApplication },
        { key = ",", mods = "LEADER", action = act.PromptInputLine {
            description = "Rename Tab:",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end)
        } },
        
        -- Splits (tmux style)
        { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
        { key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
        
        -- Pane Navigation (Vim style)
        { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
        { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
        { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
        { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
        
        -- Pane Resizing
        { key = "LeftArrow", mods = "LEADER", action = act.AdjustPaneSize { "Left", 5 } },
        { key = "DownArrow", mods = "LEADER", action = act.AdjustPaneSize { "Down", 5 } },
        { key = "UpArrow", mods = "LEADER", action = act.AdjustPaneSize { "Up", 5 } },
        { key = "RightArrow", mods = "LEADER", action = act.AdjustPaneSize { "Right", 5 } },

        -- Pane Zoom
        { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

        -- Copy Mode / Search
        { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
        { key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
        
        -- Quick Select
        { key = "Space", mods = "LEADER", action = act.QuickSelect },
        
        -- Copy & Paste
        { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
        { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

        -- Config Reload
        { key = "R", mods = "LEADER|SHIFT", action = act.ReloadConfiguration },

        -- Resize Mode (Key Chord / Table)
        { key = "r", mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },
    }

    -- Key Tables (Modes)
    config.key_tables = {
        resize_pane = {
            { key = "LeftArrow", action = act.AdjustPaneSize { "Left", 5 } },
            { key = "DownArrow", action = act.AdjustPaneSize { "Down", 5 } },
            { key = "UpArrow", action = act.AdjustPaneSize { "Up", 5 } },
            { key = "RightArrow", action = act.AdjustPaneSize { "Right", 5 } },
            { key = "h", action = act.AdjustPaneSize { "Left", 5 } },
            { key = "j", action = act.AdjustPaneSize { "Down", 5 } },
            { key = "k", action = act.AdjustPaneSize { "Up", 5 } },
            { key = "l", action = act.AdjustPaneSize { "Right", 5 } },
            -- Cancel mode
            { key = "Escape", action = "PopKeyTable" },
            { key = "Enter", action = "PopKeyTable" },
        },
    }

    -- Mouse Bindings
    config.mouse_bindings = {
        -- Right-click to paste from clipboard (Windows style)
        {
            event = { Down = { streak = 1, button = "Right" } },
            mods = "NONE",
            action = act.PasteFrom("Clipboard"),
        },
    }

    -- 1-9 Tab Navigation
    for i = 1, 9 do
        table.insert(config.keys, {
            key = tostring(i),
            mods = "LEADER",
            action = act.ActivateTab(i - 1),
        })
    end
end
