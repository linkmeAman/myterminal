local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Load modules
require('config.appearance')(config)
require('config.bindings')(config)
require('config.status')
require('config.workspaces')

-- Hyperlink & Regex Parsing
local default_rules = wezterm.default_hyperlink_rules()
-- File path:line matching (opens in VS Code)
table.insert(default_rules, {
    regex = [[\b([a-zA-Z0-9_.-/]+):(\d+)\b]],
    format = 'vscode://file/$1:$2',
})
-- Jira ticket matching
table.insert(default_rules, {
    regex = [[\bPROJ-(\d+)\b]],
    format = 'https://jira.yourcompany.com/browse/PROJ-$1',
})
config.hyperlink_rules = default_rules

-- Native Sessionizer (uses local zoxide - no internet needed)
local sessionizer = require('utils.sessionizer')
table.insert(config.keys, {
    key = "s",
    mods = "LEADER",
    action = sessionizer.switch_workspace(),
})

return config
