local awful = require("awful")
local menubar = require("menubar")
local beautiful = require("beautiful")



-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "power menu", function() awful.spawn("bash -c 'sleep 0.1; /home/xezioh/.config/rofi/powermenu/type-1/powermenu.sh'") end }
    }
})

mylauncher = awful.widget.launcher({
    image = "/home/xezioh/Media/Arch logos/Arch-24.png",
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
