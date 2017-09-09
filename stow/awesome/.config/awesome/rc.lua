-- Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table = ipairs, string, os, table
local tostring, tonumber, type = tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened
require("awful.hotkeys_popup.keys")

require("repetitive")

-- Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

local chosen_theme = "arrowpower"
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "urxvtc"
local editor       = os.getenv("EDITOR") or "vim"
local browser      = "qutebrowser --backend webengine"
local guieditor    = "urxvtc -e vim"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
awful.layout.layouts = {
    awful.layout.suit.spiral,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    -- lain.layout.cascade,
    -- lain.layout.cascade.tile,
    -- lain.layout.centerwork,
    -- lain.layout.centerwork.horizontal,
    -- lain.layout.termfair,
    -- lain.layout.termfair.center,
}

awful.util.taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
                              if client.focus then
                                  client.focus:move_to_tag(t)
                              end
                          end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                              if client.focus then
                                  client.focus:toggle_tag(t)
                              end
                          end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)
awful.util.tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
                             if c == client.focus then
                                 c.minimized = true
                             else
                                 -- Without this, the following
                                 -- :isvisible() makes no sense
                                 c.minimized = false
                                 if not c:isvisible() and c.first_tag then
                                     c.first_tag:view_only()
                                 end
                                 -- This will also un-minimize
                                 -- the client, if needed
                                 client.focus = c
                                 c:raise()
                             end
                         end),
    awful.button({ }, 3, function()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({ theme = { width = 250 } })
            end
       end
    end),
    awful.button({ }, 4, function ()
                             awful.client.focus.byidx(1)
                         end),
    awful.button({ }, 5, function ()
                             awful.client.focus.byidx(-1)
                         end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua",
                                 os.getenv("HOME"),
                                 chosen_theme)
beautiful.init(theme_path)

-- Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
    function(s)
        beautiful.at_screen_connect(s)
    end)

-- Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = awful.util.table.join(
    -- suspend, lock
    awful.key({ modkey, altkey }, "h",
        function() awful.spawn("lock_blur.sh suspend") end,
        { description = "suspend", group = "system" }
    ),
    awful.key({ modkey, altkey }, "l",
        function() awful.spawn("lock_blur.sh lock") end,
        { description = "lock the screen", group = "system" }
    ),

    -- screen brightness
    awful.key({ modkey, altkey }, "j",
        function() awful.spawn("light -U 3") end,
        { description = "decrease screen brightness", group = "system" }
    ),
    awful.key({ modkey, altkey }, "k",
        function() awful.spawn("light -A 3") end,
        { description = "increase screen brightness", group = "system" }
    ),

    -- audio volume
    awful.key({ }, "XF86AudioLowerVolume",
        function() awful.spawn("pamixer -d 3") end,
        { description = "decrease volume", group = "system" }
    ),
    awful.key({ }, "XF86AudioRaiseVolume",
        function() awful.spawn("pamixer -i 3") end,
        { description = "increase volume", group = "system" }
    ),
    awful.key({ }, "XF86AudioMute",
        function() awful.spawn("pamixer -t") end,
        { description = "toggle mute status", group = "system" }
    ),
    awful.key({ modkey }, "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    awful.key({ modkey }, "comma",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    awful.key({ modkey }, "period",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    awful.key({ modkey }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    -- Default client focus
    awful.key({ altkey }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j",
        function () awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "k",
        function () awful.client.swap.byidx( -1)    end,
        { description = "swap with previous client by index", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "j",
        function () awful.screen.focus_relative( 1) end,
        { description = "focus the next screen", group = "screen" }
    ),
    awful.key({ modkey, "Control" }, "k",
        function () awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }
    ),
    awful.key({ modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }
    ),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+",
        function () lain.util.useless_gaps_resize(1) end
    ),
    awful.key({ altkey, "Control" }, "-",
        function () lain.util.useless_gaps_resize(-1) end
    ),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n",
        function () lain.util.add_tag() end,
        { description = "add new tag", group = "tag" }
    ),
    awful.key({ modkey, "Shift" }, "r",
        function () lain.util.rename_tag() end,
        { description = "rename tag", group = "tag" }
    ),
    awful.key({ modkey, "Shift" }, "Left", -- move to previous tag
        function () lain.util.move_tag(-1) end,
        { description = "move tag to the left", group = "tag" }
    ),
    awful.key({ modkey, "Shift" }, "Right", -- move to next tag
        function () lain.util.move_tag(1) end,
        { description = "move tag to the right", group = "tag" }
    ),
    awful.key({ modkey, "Shift" }, "d",
        function () lain.util.delete_tag() end,
        { description = "delete tag", group = "tag" }
    ),

    -- Applications
    awful.key({ modkey }, "Return", -- terminal
        function () awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),
    awful.key({ modkey }, "c", -- browser
        function () awful.spawn(browser) end,
        { description = "open webbrowser", group = "launcher" }
    ),
    awful.key({ modkey }, "u", -- rofi
        function () awful.spawn("rofi -show run") end,
        { description = "open rofi", group = "launcher" }
    ),
    awful.key({ modkey }, "apostrophe", -- soundboard
        function () awful.spawn("rofi_soundbrett.sh") end,
        { description = "open rofi soundboard", group = "launcher" }
    ),
    awful.key({ modkey }, "i", -- pass menu
        function () awful.spawn("rofi-pass") end,
        { description = "open rofi pass menu", group = "launcher" }
    ),
    awful.key({ modkey }, "a", -- screenshot selector
        function () awful.spawn("screenshot.sh selxsel") end,
        { description = "take a screenshot by selecting an area",
          group = "launcher" }
    ),
    awful.key({ modkey, "Shift" }, "a", -- screenshot
        function () awful.spawn("screenshot.sh") end,
        { description = "take a screenshot", group = "launcher" }
    ),

    awful.key({ modkey, "Control" }, "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key({ modkey, "Shift" }, "e",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),
    awful.key({ altkey, "Shift" }, "l",
        function () awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key({ altkey, "Shift" }, "h",
        function () awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "h",
        function () awful.tag.incnmaster(1, nil, true) end,
        {
            description = "increase the number of master clients",
            group = "layout"
        }
    ),
    awful.key({ modkey, "Shift" }, "l",
        function () awful.tag.incnmaster(-1, nil, true) end,
        {
            description = "decrease the number of master clients",
            group = "layout"
        }
    ),
    awful.key({ modkey, "Control" }, "h",
        function () awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),
    awful.key({ modkey, "Control" }, "l",
        function () awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),
    awful.key({ modkey }, "space",
        function () awful.layout.inc(1) end,
        { description = "select next", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "space",
        function () awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }
    ),
    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    -- Dropdown terminal
    awful.key({ modkey, }, "z",
        function () awful.screen.focused().quake:toggle() end,
        { description = "toggle dropdown terminal", group = "launcher" }
    ),

    awful.key({ modkey }, "r",
        function () awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }
    ),
    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" })
)

clientkeys = awful.util.table.join(
    awful.key({ altkey, "Shift" }, "m",
        lain.util.magnify_client
    ),
    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key({ modkey, }, "q",
        function (c) c:kill() end,
        { description = "close", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle                     ,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "Return",
        function (c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
    ),
    awful.key({ modkey }, "o",
        function (c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }
    ),
    awful.key({ modkey }, "t",
        function (c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
    ),
    awful.key({ modkey }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }
    ),
    awful.key({ modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        { description = "maximize", group = "client" }
    )
)

-- Bind all key numbers to tags.
local tag_mappings = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
for i,v in ipairs(tag_mappings) do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, v,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, v,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, v,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
               end
            end,
            { description = "move focused client to tag #"..i, group = "tag" }),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, v,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {
                description = "toggle focused client on tag #" .. i,
                group = "tag"
            })
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },

    -- Titlebars
    -- {
    --     rule_any = { type = { "dialog", "normal" } },
    --     properties = { titlebars_enabled = true }
    -- },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer"
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }
}


-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 16}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized then -- no borders if only 1 client visible
            c.border_width = 0
        elseif #awful.screen.focused().clients > 1 then
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus",
    function(c) c.border_color = beautiful.border_normal end)

