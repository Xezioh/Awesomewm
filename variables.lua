local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "/themes/default/theme.lua")
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default")
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- disables snapping stuff
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false

-- Mod key
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.fair.horizontal,
}

-- }}}
