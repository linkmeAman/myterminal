local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

-- Query zoxide's top directories and present a fuzzy picker
M.switch_workspace = function()
    return wezterm.action_callback(function(window, pane)
        -- Pull top dirs from zoxide inside WSL Ubuntu
        local success, stdout, stderr = wezterm.run_child_process {
            "wsl", "-d", "Ubuntu", "--", "bash", "-c", "zoxide query --list --score"
        }

        if not success then
            wezterm.log_error("Sessionizer: zoxide failed - " .. (stderr or ""))
            return
        end

        local choices = {}
        for line in stdout:gmatch("[^\n]+") do
            -- Each line: "score   /path/to/dir"
            local score, path = line:match("^%s*([%d%.]+)%s+(.+)$")
            if path then
                table.insert(choices, {
                    label = path,
                    id    = path,
                })
            end
        end

        if #choices == 0 then
            wezterm.log_warn("Sessionizer: zoxide database is empty. Visit some directories first!")
            return
        end

        window:perform_action(
            act.InputSelector {
                action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
                    if not id then return end
                    local workspace_name = id:match("([^/\\]+)$") or id
                    inner_window:perform_action(
                        act.SwitchToWorkspace {
                            name    = workspace_name,
                            spawn   = { cwd = id },
                        },
                        inner_pane
                    )
                end),
                fuzzy       = true,
                title       = "  Project Sessionizer",
                choices     = choices,
            },
            pane
        )
    end)
end

return M
