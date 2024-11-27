-- Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi

local taglist = require("ui.bar.taglist")
local tasklist = require("ui.bar.tasklist")
local layoutbox = require("ui.bar.layoutbox")
local mylayoutbox = wibox.container.margin(layoutbox(s), dpi(4), dpi(4), dpi(4), dpi(4))

local cpu_widget = require("ui.bar.widgets.cpu")
local clock_widget = require("ui.bar.widgets.clock")
local battery_widget = require("ui.bar.widgets.battery")
--local wifi_widget = require("ui.bar.widgets.wifi")
local date_widget = require("ui.bar.widgets.date")
local memory_widget = require("ui.bar.widgets.memory")
local volume_widget = require("ui.bar.widgets.volume")
local brightness_widget = require("ui.bar.widgets.brightness")

local function barcontainer(widget)
    local container = wibox.widget
        {
            widget,
            left = dpi(1),
            right = dpi(1),
            widget = wibox.container.margin
        }
    local box = wibox.widget {
        {
            container,
            top = dpi(1),
            bottom = dpi(1),
            left = dpi(2),
            right = dpi(2),
            widget = wibox.container.margin
        },
        bg = beautiful.bg_bar,
        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 0) end,
        widget = wibox.container.background
    }
    return wibox.widget {
        box,
        top = dpi(1),
        bottom = dpi(1),
        right = dpi(1),
        left = dpi(1),
        widget = wibox.container.margin
    }
end

local separator = wibox.widget {
    markup = '<span font="' .. beautiful.font_u .. '">| </span>',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}
local lang = wibox.widget {
    {
        awful.widget.keyboardlayout(),
        left = 10,
        top = 0,
        bottom = 0,
        right = 10,

        
        widget = wibox.container.margin,
    },
    
    bg = "#3c3836",
    
    shape = gears.shape.rounded_bar,
    shape_clip = true,
    widget = wibox.container.background,
}
local bat = wibox.widget {
    {
        battery_widget,
        left = 10,
        top = 0,
        bottom = 0,
        right = 10,


        widget = wibox.container.margin,
    },
    
    bg = "#3c3836",
    
    shape = gears.shape.rounded_bar,
    shape_clip = true,
    widget = wibox.container.background,
}
local systray = wibox.widget {
    visible = true,
    base_size = dpi(40),
    horizontal = true,
    screen = 'primary',
    {
        {
            {
                wibox.widget.systray,
                layout = wibox.layout.fixed.horizontal,
            },
            margins = { top = dpi(0), bottom = dpi(0), left = dpi(6), right = dpi(6) },
            widget = wibox.container.margin,
        },
        bg = "#252525",
        widget = wibox.container.background,
    },
    
    margins = { top = dpi(6), bottom = dpi(6) },
    widget = wibox.container.margin,
}

local widgetscollection = wibox.widget {
    {
        barcontainer(volume_widget),
        barcontainer(brightness_widget),
        barcontainer(cpu_widget),
        barcontainer(memory_widget),
        bat,
        barcontainer(date_widget),
        barcontainer(clock_widget),
        spacing = dpi(4),
        layout = wibox.layout.fixed.horizontal,
    },
    margins = { top = dpi(1), bottom = dpi(1), },
    widget = wibox.container.margin,
}

-- This function creates and configures a wibar (widget bar)
-- It includes a horizontal layout containing taglist, tasklist, and system tray.
-- The wibar is designed to display information and provide interaction points for the user,
-- organizing essential widgets in a convenient and aesthetically pleasing manner at the top of the screen.
local function get_bar(s)
    s.mywibar = awful.wibar({
        position = "top",
        height = dpi(30),
        width = s.geometry.width,
        screen = s,
        bg = "#252525"
    })

    s.mywibar:setup({
        {
            {
                layout = wibox.layout.align.horizontal,
                {
                    taglist(s),
                    layout = wibox.layout.fixed.horizontal,
                },
                {
                    tasklist(s),
                    layout = wibox.layout.flex.horizontal,
                },
                {
                    systray,
                    lang,
                    widgetscollection,
                    
                    mylayoutbox,
                    layout = wibox.layout.fixed.horizontal,
                },
            },
            widget = wibox.container.margin,
        },
        widget = wibox.container.background,
    })
end

screen.connect_signal("request::desktop_decoration", function(s)
    get_bar(s)
end)
