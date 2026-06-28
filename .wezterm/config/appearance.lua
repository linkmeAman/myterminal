local wezterm = require 'wezterm'
local helpers = require 'utils.helpers'

return function(config)
    -- Color scheme (Dynamic based on OS appearance)
    if wezterm.gui then
        local appearance = wezterm.gui.get_appearance()
        if appearance:find("Dark") then
            config.color_scheme = "Catppuccin Mocha"
        else
            config.color_scheme = "Catppuccin Latte"
        end
    else
        config.color_scheme = "Catppuccin Mocha"
    end

    -- Fonts (cross platform fallbacks)
    config.font = wezterm.font_with_fallback({
        "JetBrains Mono", -- Natively bundled in WezTerm!
        "Symbols Nerd Font Mono", -- Natively bundled for all icons!
        "Consolas",
    })
    config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' } -- Enable programming ligatures
    config.font_size = helpers.is_mac and 14.0 or 12.0
    config.line_height = 1.25 -- Increased for readability

    -- Cursor Styling
    config.default_cursor_style = "BlinkingBar"
    config.colors = {
        cursor_bg = "#f38ba8", -- Bright neon pink/red from Catppuccin
        cursor_border = "#f38ba8",
        cursor_fg = "#11111b",
    }

    -- Window Decor/Tabs
    if helpers.is_windows then
        config.window_decorations = "RESIZE" -- Completely removes the ugly OS title bar
        config.win32_system_backdrop = "Acrylic"
    elseif helpers.is_mac then
        config.window_decorations = "RESIZE"
        config.macos_window_background_blur = 20
    else
        config.window_decorations = "RESIZE"
    end

    config.use_fancy_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = false
    config.tab_bar_at_bottom = false
    config.tab_max_width = 32

    -- Layout
    config.window_padding = {
        left = 24,
        right = 24,
        top = 24,
        bottom = 24,
    }

    -- Enable Windows 11 Acrylic Blur
    config.win32_system_backdrop = 'Acrylic'
    config.window_background_opacity = 0.85
    config.text_background_opacity = 1.0
    
    config.inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.6,
    }

    -- Performance
    config.front_end = "WebGpu"
    config.webgpu_power_preference = "HighPerformance"
    config.animation_fps = 120
    config.max_fps = 120
    config.check_for_updates = false
    
    -- Scrollback
    config.scrollback_lines = 50000
    
    -- Cursor
    config.default_cursor_style = "BlinkingBar"
    config.cursor_blink_rate = 500
    config.cursor_thickness = 2
    
    -- Custom flat modern tabs matching Catppuccin Mocha
    config.colors = {
        tab_bar = {
            background = "#11111b",
            active_tab = {
                bg_color = "#cba6f7",
                fg_color = "#11111b", 
                intensity = "Bold",
            },
            inactive_tab = {
                bg_color = "#181825",
                fg_color = "#bac2de",
            },
            inactive_tab_hover = {
                bg_color = "#313244",
                fg_color = "#cdd6f4",
            },
            new_tab = { bg_color = "#11111b", fg_color = "#bac2de" },
            new_tab_hover = { bg_color = "#313244", fg_color = "#cdd6f4" },
        }
    }
end
