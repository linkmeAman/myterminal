local wezterm = require 'wezterm'

local module = {}

module.is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"
module.is_mac = wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin"
module.is_linux = wezterm.target_triple == "x86_64-unknown-linux-gnu"

-- Helper to get a clean basename of a path
function module.basename(path)
    return string.match(path, "^.+[/\\](.-)$") or path
end

return module
