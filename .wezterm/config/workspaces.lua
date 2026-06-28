local wezterm = require 'wezterm'
local mux = wezterm.mux
local helpers = require 'utils.helpers'

wezterm.on("gui-startup", function(cmd)
    -- We can set up a default startup layout here if needed.
    -- To keep it clean, we just spawn a default window.
    local tab, pane, window = mux.spawn_window(cmd or {})
    
    if helpers.is_windows then
        window:gui_window():maximize()
    end
end)

-- You can define custom events to bootstrap specific workspaces
-- e.g. wezterm cli spawn --workspace AI
wezterm.on('mux-startup', function()
    -- Create predefined workspaces in the background so they are ready to switch to

    -- 1. Backend Workspace
    local backend_tab, backend_pane, backend_window = mux.spawn_window {
        workspace = 'Backend',
    }
    backend_pane:split { direction = 'Right', size = 0.3 }

    -- 2. AI Workspace
    local ai_tab, ai_pane, ai_window = mux.spawn_window {
        workspace = 'AI',
    }
    ai_pane:split { direction = 'Bottom', size = 0.25 }
    
    -- 3. DevOps Workspace
    local devops_tab, devops_pane, devops_window = mux.spawn_window {
        workspace = 'DevOps',
    }
    devops_pane:split { direction = 'Right', size = 0.5 }
    
    -- Set focus back to default workspace if needed, 
    -- though usually it starts in 'default' anyway.
end)

return {}
