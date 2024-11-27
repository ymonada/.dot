-- Required libraries
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", }, s, awful.layout.layouts[1])

end)

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
return function(s)
  local tag = awful.widget.taglist {
    screen  = s,
        filter  =awful.widget.taglist.filter.all,
        layout   = {
                    spacing = 0,
                   
                    layout  = wibox.layout.fixed.horizontal,
                    
                },
        style   = {
            bg_empty = bg_emp,
            fg_empty= cl_fg_empty,
            bg_occupied = cl_bg_occupied,
            fg_occupied = cl_fg_occupied,
            fg_focus = cl_fg_focus,
            bg_focus = cl_bg_focus,
            fg_urgent = cl_fg_urgent,
            bg_urgent = cl_bg_urgent,
            shape_border_color_focus = cl_shape_border_color_focus,
            shape_border_width = cl_shape_border_width,
            shape_border_color = cl_shape_border_color,
           -- shape = gears.shape.rectangle,
            },
        buttons = {
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
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
  }

  return tag
end
