local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local os, math, string = os, math, string

local black                 = "#222222"
local black2                = "#1E2320"
local black_lighter         = "#636363"
local black_light           = "#484848"
local white                 = "#FEFEFE"
local orange                = "#CB755B"
local grey                  = "#777E76"
local grey2                 = "#C3C3C3"
local green1                = "#8DAA9A"
local green2                = "#4B696D"
local green3                = "#9DAF37"
local purple                = "#4B3B51"
local blue                  = "#B8D6F0"

local theme                 = {}
theme.dir                   = os.getenv("HOME") .. "/.config/awesome/themes/arrowpower"
theme.wallpaper             = os.getenv("HOME") .. "/sync/wallpaper/40122162-low-poly-wallpapers.png"

theme.font                  = "Inconsolata for Powerline 11"
theme.menu_height           = 16
theme.menu_width            = 140
theme.useless_gap           = 0

theme.taglist_fg_focus      = white
theme.taglist_bg_focus      = orange
theme.taglist_fg_occupied   = white
theme.taglist_bg_occupied   = black_light
theme.taglist_fg_empty      = white
theme.taglist_bg_empty      = black_light

theme.fg_normal             = white
theme.fg_focus              = "#32D6FF"
theme.fg_urgent             = "#C83F11"
theme.bg_normal             = black
theme.bg_focus              = orange
theme.bg_urgent             = "#3F3F3F"

theme.tasklist_bg_focus     = black_lighter
theme.tasklist_fg_focus     = white
theme.tasklist_bg_normal    = black_light
theme.tasklist_fg_normal    = white

theme.border_width          = 2
theme.border_normal         = "#3F3F3F"
theme.border_focus          = green3
theme.border_marked         = "#CC9393"

theme.titlebar_bg_focus     = "#3F3F3F"
theme.titlebar_bg_normal    = "#3F3F3F"
theme.titlebar_bg_focus     = theme.bg_focus
theme.titlebar_bg_normal    = theme.bg_normal
theme.titlebar_fg_focus     = theme.fg_focus

local task_shape = function(cr, width, height)
    gears.shape.powerline(cr, width, height, -height/2)
end
theme.tasklist_shape        = task_shape
theme.tasklist_align        = "center"
theme.tasklist_disable_icon = true

idir = theme.dir .. "/icons/"
tdir = theme.dir .. "/icons/titlebar/"

theme.menu_submenu_icon                         = idir .. "submenu.png"
theme.awesome_icon                              = idir .. "awesome.png"
theme.taglist_squares_sel                       = idir .. "square_sel.png"
theme.taglist_squares_unsel                     = idir .. "square_unsel.png"
-- theme.layout_tile                               = idir .. "tile.png"
-- theme.layout_tileleft                           = idir .. "tileleft.png"
-- theme.layout_tilebottom                         = idir .. "tilebottom.png"
-- theme.layout_tiletop                            = idir .. "tiletop.png"
-- theme.layout_fairv                              = idir .. "fairv.png"
-- theme.layout_fairh                              = idir .. "fairh.png"
-- theme.layout_spiral                             = idir .. "spiral.png"
-- theme.layout_dwindle                            = idir .. "dwindle.png"
-- theme.layout_max                                = idir .. "max.png"
-- theme.layout_fullscreen                         = idir .. "fullscreen.png"
-- theme.layout_magnifier                          = idir .. "magnifier.png"
-- theme.layout_floating                           = idir .. "floating.png"
theme.widget_ac                                 = idir .. "ac.png"
theme.widget_battery                            = idir .. "battery.png"
theme.widget_battery_low                        = idir .. "battery_low.png"
theme.widget_battery_empty                      = idir .. "battery_empty.png"
theme.widget_mem                                = idir .. "mem.png"
theme.widget_cpu                                = idir .. "cpu.png"
theme.widget_temp                               = idir .. "temp.png"
theme.widget_net                                = idir .. "net.png"
theme.widget_hdd                                = idir .. "hdd.png"
theme.widget_music                              = idir .. "note.png"
theme.widget_music_on                           = idir .. "note_on.png"
theme.widget_music_pause                        = idir .. "pause.png"
theme.widget_music_stop                         = idir .. "stop.png"
theme.widget_vol                                = idir .. "vol.png"
theme.widget_vol_low                            = idir .. "vol_low.png"
theme.widget_vol_no                             = idir .. "vol_no.png"
theme.widget_vol_mute                           = idir .. "vol_mute.png"
theme.widget_mail                               = idir .. "mail.png"
theme.widget_mail_on                            = idir .. "mail_on.png"
theme.widget_task                               = idir .. "task.png"
theme.widget_scissors                           = idir .. "scissors.png"

theme.titlebar_close_button_focus               = tdir .. "close_focus.png"
theme.titlebar_close_button_normal              = tdir .. "close_normal.png"
theme.titlebar_ontop_button_focus_active        = tdir .. "ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = tdir .. "ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = tdir .. "ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = tdir .. "ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = tdir .. "sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = tdir .. "sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = tdir .. "sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = tdir .. "sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = tdir .. "floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = tdir .. "floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = tdir .. "floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = tdir .. "floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = tdir .. "maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = tdir .. "maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = tdir .. "maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = tdir .. "maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp (lain, average)
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})

-- / fs
local fsicon = wibox.widget.imagebox(theme.widget_hdd)
theme.fs = lain.widget.fs({
    options  = "--exclude-type=tmpfs",
    notification_preset = {
            fg = theme.fg_normal,
            bg = theme.bg_normal,
            font = "Terminus (TTF) 10"
        },
    settings = function()
        widget:set_markup(
            markup.font(theme.font, " " .. fs_now.available_gb .. "GB "))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    batteries = {"BAT0", "BAT1"}, -- dual Lenovo battery
    settings = function()
        set = false
        for _,v in pairs(bat_now.n_status) do
            if v == "Charging" then
                baticon:set_image(theme.widget_ac)
                set = true
            end
        end
        if not set then
            baticon:set_image(theme.widget_battery)
        end

        widget:set_markup(markup.font(theme.font,
            " " .. bat_now.n_perc[1] .. "% / " .. bat_now.n_perc[2] .. "%"))
    end
})

local arrow = separators.arrow_left

local sep_shape = function(cr, width, height)
    gears.shape.transform(gears.shape.rectangular_tag)
        : rotate_at(width/2, height/2, math.pi)
        (cr, width, height, -height/2)
end
local taglist_separator = wibox.container.background(wibox.widget.textbox(""),
                                                     black_light,
                                                     sep_shape)
taglist_separator.forced_width = 15
taglist_separator.forced_height = 20

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating
    -- which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s,
                                       awful.widget.taglist.filter.all,
                                       awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(
        s, awful.widget.tasklist.filter.currenttags,
        awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = 20,
        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,

        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            taglist_separator,
            s.mypromptbox,
        },

        -- Middle widget
        wibox.container.background(wibox.container.margin(s.mytasklist, 0, 0),
                                   black),

        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,

            arrow("alpha", grey),
            wibox.container.background(
                wibox.container.margin(wibox.widget {
                    memicon,
                    mem.widget,
                    layout = wibox.layout.align.horizontal
                }, 2, 6), grey),

            arrow(grey, green2),
            wibox.container.background(
                wibox.container.margin(wibox.widget {
                    cpuicon,
                    cpu.widget,
                    layout = wibox.layout.align.horizontal
                }, 3, 6), green2),

            arrow(green2, purple),
            wibox.container.background(
                wibox.container.margin(wibox.widget {
                    tempicon,
                    temp.widget,
                    layout = wibox.layout.align.horizontal
                }, 4, 6), purple),

            arrow(purple, orange),
            wibox.container.background(
                wibox.container.margin(wibox.widget {
                    fsicon,
                    theme.fs.widget,
                    layout = wibox.layout.align.horizontal
                }, 3, 6), orange),

            arrow(orange, green1),
            wibox.container.background(
                wibox.container.margin(wibox.widget {
                    baticon,
                    bat.widget,
                    layout = wibox.layout.align.horizontal
                }, 3, 6), green1),

            arrow(green1, grey),
            wibox.container.background(
                wibox.container.margin(wibox.widget.textclock(), 3, 3),
                grey),

            arrow(grey, green2),
            wibox.container.background(
                wibox.container.margin(s.mylayoutbox, 6, 8),
                green2),
            arrow(green2, black),

            wibox.widget.systray()
        },
    })
end

return theme
