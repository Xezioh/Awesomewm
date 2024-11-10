local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- anything added here will start in floating mode
    {
        rule_any = {
            instance = {
                "pinentry",
                "kitty",
                "Nemo", "nemo",
                "carla",
                "openrgb",
                "StreamController",
                "pavucontrol",
                "proton pass",
                "proton mail",
                "sublime_text" , "Sublime_text",
                "spotify", "Spotify",
                "nvidia-settings",
                "caprine",
                "missioncenter",
                "flameshot",
                "loupe",
                "Vial",
                "via-nativia"


            },

            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Rule for Firefox
     {
        rule = { class = "firefox" },  -- Adjust class based on `xprop` output
        properties = {
            maximized = false,
            floating = false,
            tag = "1",
        }
    },

        -- Rule for Plex
    {
        rule = { class = "Plex" },
        properties = {
            screen = screen.primary, -- Place on primary screen
            maximized = true
        }
    },

}

-- }}}
