local awful = require("awful")
local beautiful = require("beautiful")

-- Define a custom layout
local vertical_stack_with_floating = {}

-- Set up layouts for each screen
awful.screen.connect_for_each_screen(function(s)
    if s.index == 2 then
        -- Set `1x3` layout only for the second screen (index 2)
        awful.tag(
            { "1", "2", "3" },               -- Define the tags for the second screen
            s,
            { vertical_stack_with_floating } -- Only use the custom layout for these tags
        )
    else
        -- Use default layouts for the primary or other screens
        awful.tag(
            { "1", "2", "3" },      -- Define the tags for the other screens
            s,
            awful.layout.layouts[1] -- Choose any default layout (e.g., `awful.layout.suit.tile`)
        )
    end
end)

-- Layout name
vertical_stack_with_floating.name = "1x3"

-- Shrink amount in pixels for spacing between windows
local shrink_amount = 4

-- Border width in pixels
local border_width = beautiful.border_width or 1

-- Padding around the edges of the screen
local padding = 0 -- Adjust padding if needed

-- Extra height in pixels for top and middle windows
local extra_height = 70 -- Increased extra height for better fit

-- Helper function to round numbers to the nearest integer
local function round(num)
    return math.floor(num + 0.5)
end

-- Arrange function
function vertical_stack_with_floating.arrange(p)
    local clients = p.clients
    local workarea = p.workarea

    -- Account for the bar height
    local bar_height = beautiful.bar_height or 0
    local effective_workarea_height = workarea.height - bar_height

    -- Number of zones (fixed to 3 as requested)
    local num_zones = 3
    local total_shrink_amount = shrink_amount * (num_zones - 1)
    local zone_height = (effective_workarea_height - total_shrink_amount - (2 * extra_height)) / num_zones

    -- If there are no clients, return
    if #clients == 0 then return end

    -- Define floating and tiling clients
    local floating_clients = {}
    local tiling_clients = {}

    -- Separate floating and tiling clients
    for _, c in ipairs(clients) do
        if c.floating then
            table.insert(floating_clients, c)
        else
            table.insert(tiling_clients, c)
        end
    end

    -- Adjust work area width without shifting the x position to avoid left gap
    local adjusted_workarea_width = workarea.width - shrink_amount - 2 * padding

    -- Track the total height occupied by windows
    local total_height_occupied = 0

    -- Arrange tiling clients in vertical stack
    for i, c in ipairs(tiling_clients) do
        local zone_y = workarea.y + bar_height + total_height_occupied + padding

        -- Calculate the new geometry within the monitor bounds
        local new_geom = {
            x = workarea.x + padding, -- Add padding to x position
            y = zone_y,
            width = adjusted_workarea_width,
            height = zone_height
        }

        -- Increase height for top and middle windows
        if i == 1 or i == 2 then
            new_geom.height = zone_height + extra_height -- Increase height for top and middle windows
        end

        -- If this is the last (bottom) window, adjust its height and position
        if i == #tiling_clients then
            local bottom_window_height = effective_workarea_height - total_height_occupied - padding - border_width - 1

            -- Ensure height is not negative and fits within the available space
            if bottom_window_height < border_width then
                bottom_window_height = border_width
            end

            new_geom.height = bottom_window_height
            new_geom.y = new_geom.y - 1 -- Move bottom window up by 1 pixel
        end

        -- Round values to avoid pixel overlap
        new_geom.x = round(new_geom.x)
        new_geom.y = round(new_geom.y)
        new_geom.width = round(new_geom.width)
        new_geom.height = round(new_geom.height)

        -- Apply the adjusted geometry
        c:geometry(new_geom)

        -- Update total height occupied including shrink_amount
        total_height_occupied = total_height_occupied + new_geom.height + shrink_amount
    end

    -- Ensure no window is overlapping to the right or down
    for _, c in ipairs(tiling_clients) do
        local g = c:geometry()
        -- Ensure windows do not extend beyond the right boundary
        if g.x + g.width > workarea.x + adjusted_workarea_width + padding then
            g.width = (workarea.x + adjusted_workarea_width + padding) - g.x
        end
        -- Ensure windows do not extend beyond the bottom boundary
        if g.y + g.height > workarea.y + workarea.height then
            g.height = (workarea.y + workarea.height) - g.y
        end
        -- Apply the adjusted geometry
        c:geometry(g)
    end

    -- Arrange floating clients
    for _, c in ipairs(floating_clients) do
        local g = c:geometry()

        -- Ensure floating windows stay within the workarea
        if g.x < workarea.x then g.x = workarea.x end
        if g.y < workarea.y then g.y = workarea.y end
        if g.x + g.width > workarea.x + adjusted_workarea_width + padding then
            g.x = (workarea.x + adjusted_workarea_width + padding) - g.width
        end
        if g.y + g.height > workarea.y + workarea.height then
            g.y = (workarea.y + workarea.height) - g.height
        end

        -- Round values to avoid pixel overlap
        g.x = round(g.x)
        g.y = round(g.y)
        g.width = round(g.width)
        g.height = round(g.height)

        -- Apply the adjusted geometry
        c:geometry(g)
    end
end

-- Return the layout so it can be used
return vertical_stack_with_floating
