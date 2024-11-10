
-- ~/.config/awesome/wallpaper.lua

local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

local function set_wallpaper(s)
    -- Define wallpapers for each screen
    local wallpapers = {
        "/home/xezioh/Media/wallpapers/on the way to hell.png",  -- Wallpaper for the first screen
        "/home/xezioh/Media/wallpapers/AdobeStock_553881299.rotated.jpeg"   -- Wallpaper for the second screen
    }

    -- Get the appropriate wallpaper for the screen
    local wallpaper = wallpapers[s.index] or wallpapers[1]  -- Default to the first wallpaper if index is out of range

    gears.wallpaper.maximized(wallpaper, s, true)
end


-- Re-set wallpaper when a screen's geometry changes (e.g., different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Set the wallpaper for each screen
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)

return set_wallpaper