-- Required libraries
local awful = require("awful")
local wibox = require("wibox")


local bg_emp = "#252525"

cl_fg_empty = "#585858"
cl_bg_occupied = "#585858"
cl_fg_occupied = "#fff"
cl_fg_focus = "#000000"
cl_bg_focus = "#ebdbb2"
cl_fg_urgent = "#000"
cl_bg_urgent = "#f53c3c"
cl_shape_border_color = "#000"
cl_shape_border_color_urgent = "#f53c3c"
cl_shape_border_color_focus = '#000'
cl_shape_border_width = 0
cl_shape_border_color = '#000'


cl_fg_volatile = "#000000"
cl_bg_volatile = "#8ec07c"
cl_fg_minimaze = "#ebdbb2"
cl_bg_minimaze = "#83a598"
-- This function creates a tasklist widget
-- It displays only visible clients on the screen.
-- The tasklist allows interaction with client windows:
--   - Left click on a client to toggle minimization or focus it.
--   - Right click to open a menu listing all active clients.
local tasklist = function(s)
    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        style    = {
            --shape_border_width = 2,
            fg_focus = cl_fg_focus,
            bg_focus = cl_bg_focus,
            fg_minimize = cl_fg_minimaze,
            bg_minimize = cl_bg_minimaze,
            bg_normal = cl_bg_occupied,
            fg_normal = cl_fg_occupied,
            bg_volatile = cl_bg_volatile,
            fg_volatile = cl_fg_volatile,
            
        },
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 300 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        },
        -- layout = {
        --     layout = wibox.layout.fixed.horizontal
        -- },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            forced_width = 15,
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                            id     = 'text_role',
                            widget = wibox.widget.textbox,

                    },
                    layout = wibox.layout.align.horizontal,
                },
                left  = 10,
                right = 10,
                forced_width = 330,
                
                widget = wibox.container.margin,
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }
end

return tasklist
