-- ~/.config/awesome/autostart.lua
local awful = require("awful")
local gfs = require("gears.filesystem")

-- Directory to track already started applications
local autostart_dir = "/tmp/awesomewm-autostart/"

-- Function to run a command only if it's not already run, using a unique identifier
local function run_once(cmd, id)
    local findme = cmd:match("^[^ ]+")
    -- Use a unique identifier or the command itself as a fallback
    local cmd_flag = autostart_dir .. (id or findme)

    -- Check if the flag file exists
    if not gfs.file_readable(cmd_flag) then
        -- Run the command if the flag file doesn't exist and create the flag file
        awful.spawn.with_shell(string.format(
            "pgrep -u $USER -x %s > /dev/null || (%s &)", findme, cmd))
        awful.spawn.with_shell(string.format("touch %s", cmd_flag))
    end
end

-- Create the directory if it doesn't exist
awful.spawn.with_shell("mkdir -p " .. autostart_dir)


-- Auto-start applications using run_once to prevent duplicates
run_once ("pavucontrol")

run_once ("flatpak run com.core447.StreamController")
run_once("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")

-- Use unique IDs for each xrandr command
run_once ("xrandr --output HDMI-0 --scale 1.25x1.25 --rotate left --left-of DP-4", "xrandr-secondary-size")
run_once ("xrandr --output DP-4 --pos 1350x960", "xrandr-main-pos")
run_once ("pactl load-module module-loopback latency_msec=1", "pactctl-loopback")
run_once ("pactl load-module module-null-sink media.class=Audio/Sink sink_name=Virtual-Mic channel_map=front-left,front-right", "pactctl-null-sink-sink")
run_once ("pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Virtual-Mic channel_map=front-left,front-right", "pactctl-null-sink-source-virtual")
run_once ("pw-link Virtual-Mic:monitor_FL Virtual-Mic:input_FL", "pw-link-FL")
run_once ("pw-link Virtual-Mic:monitor_FR Virtual-Mic:input_FR", "pw-link-FR")