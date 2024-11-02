-- ~/.config/awesome/config/bar.lua
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears

-- Function to create the bar
local function create_bar(s)
    -- Create tasklist
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        style = {
            shape = gears.shape.rounded_rect,
            icon_only = true,
        },
        layout = {
            spacing = 5,
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                {
                    id = 'clienticon',
                    forced_height = 24,
                    forced_width = 24,
                    widget = awful.widget.clienticon,
                },
                margins = 5,
                widget = wibox.container.margin,
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c, index, objects)
                self:get_children_by_id('clienticon')[1].client = c
            end,
        },
        buttons = awful.util.table.join(
            awful.button({}, 1, function(c)
                local client_list = {}

                -- Group windows by class
                for _, client_instance in ipairs(c:tags()[1]:clients()) do
                    if client_instance.class == c.class then
                        table.insert(client_list, client_instance)
                    end
                end

                if #client_list > 1 then
                    local instance_menu = awful.menu({ items = {} })

                    for _, client_instance in ipairs(client_list) do
                        instance_menu:add({
                            client_instance.name,
                            function()
                                client_instance:emit_signal("request::activate", "tasklist", { raise = true })
                            end
                        })
                    end

                    instance_menu:show()
                else
                    c:emit_signal("request::activate", "tasklist", { raise = true })
                end
            end)
        )
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Setup the wibox layout
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mypromptbox,
        },
        -- Centering the tasklist
        {
            layout = wibox.layout.align.horizontal,
            expand = "none", -- Don't expand this section
            s.mytasklist, -- Centered tasklist
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end

return create_bar
