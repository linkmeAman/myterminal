local wezterm = require 'wezterm'

-- Custom Right Status (and Left Workspace)
wezterm.on("update-status", function(window, pane)
    local workspace = window:active_workspace()
    
    local stat = window:active_key_table()
    if stat then stat = "MODE: " .. stat end
    
    local right_status = {}
    
    -- Left status (Workspace)
    local left_status = wezterm.format({
        { Background = { Color = "#11111b" } },
        { Foreground = { Color = "#cba6f7" } },
        { Text = "  󰇄  " .. workspace .. "  " },
    })
    window:set_left_status(left_status)

    -- LEADER BADGE
    if window:leader_is_active() then
        table.insert(right_status, { Background = { Color = "#f38ba8" } })
        table.insert(right_status, { Foreground = { Color = "#11111b" } })
        table.insert(right_status, { Text = " LEADER " })
    end

    if stat then
        table.insert(right_status, { Background = { Color = "#f38ba8" } })
        table.insert(right_status, { Foreground = { Color = "#11111b" } })
        table.insert(right_status, { Text = " " .. stat .. " " })
    end
    
    -- Time
    table.insert(right_status, { Background = { Color = "#11111b" } })
    table.insert(right_status, { Foreground = { Color = "#b4befe" } })
    table.insert(right_status, { Text = "  " .. wezterm.strftime('%H:%M') .. "  " })
    
    window:set_right_status(wezterm.format(right_status))
end)

-- Custom Tab Bar Formatting
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = tab.tab_index + 1 .. ": " .. (tab.active_pane.title or "")
    
    -- Ensure it doesn't get too long
    if #title > max_width - 2 then
        title = wezterm.truncate_right(title, max_width - 4) .. ".."
    end
    
    if tab.is_active then
        return {
            { Background = { Color = "#b4befe" } },
            { Foreground = { Color = "#11111b" } },
            { Text = "  " .. title .. "  " },
        }
    else
        return {
            { Background = { Color = "#1e1e2e" } },
            { Foreground = { Color = "#a6adc8" } },
            { Text = "  " .. title .. "  " },
        }
    end
end)

return {}
