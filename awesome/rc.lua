pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
beautiful.init("some_theme.lua")
local naughty = require("naughty")
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

terminal = "alacritty"
browser = "firefox"
telegram = "telegram-desktop"
exprorer = "nemo"
volume = "pavucontrol"
rofi = "rofi -show drun"
discord = "discord"
steam = "steam"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"
altkey = "Mod1"

myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
   {"PowerOff", terminal .. "systemcttl poweroff" },
   {"Reboot", terminal .. "systemcttl reboot" },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal, beautiful.awesome_icon}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw,
    })
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
-- Индикатор раскладки клавиатуры
mykeyboardlayout = awful.widget.keyboardlayout()

local lang = wibox.widget {
    {
        awful.widget.keyboardlayout(),
        left = 10,
        top = 0,
        bottom = 0,
        right = 10,
        widget = wibox.container.margin,
    },
    
    bg = "#3c3836e6",
    
    shape = gears.shape.rounded_bar,
    shape_clip = true,
    widget = wibox.container.background,
}

-- Часы текст
mytextclock = wibox.widget.textclock()
local battery_widget = require("battery_widget")
local cpu_widget = require("cpu")
local mem_widget = require("mem")
local volume_widget = require("volume")

local bat = wibox.widget {
    {
        battery_widget,
        left = 10,
        top = 0,
        bottom = 0,
        right = 5,
        widget = wibox.container.margin,
    },
    
    bg = "#3c3836e6",
    
    shape = gears.shape.rounded_bar,
    shape_clip = true,
    widget = wibox.container.background,
}

screen.connect_signal("request::desktop_decoration", function(s)

    awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ",}, s, awful.layout.layouts[2])
    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    s.mytaglist = awful.widget.taglist {
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
            shape = gears.shape.rectangle,
            },
            -- shape  = gears.shape.rectangle,
        
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
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        
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
        buttons = {
                    awful.button({ }, 1, function (c)
                        c:activate { context = "tasklist", action = "toggle_minimization" }
                    end),
                    awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 300 } } end),
                    awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
                    awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
                }
    }  

    local tray = wibox.widget.systray()
    s.mywibox = awful.wibar({
          position = "top",
          screen = s,
          border_width = 0,
          x = 0, y = 0,
          bg = "#000",
          height = 35,

        }
     )
    s.mywibox:setup {
        
        layout = wibox.layout.align.horizontal,
        { 
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
           
            s.mytaglist,
        },
        {
            s.mytasklist,
            layout  = wibox.layout.flex.horizontal,
        },
        {
            tray,
            volume_widget,
            lang,
            --cpu_widget,
            --mem_widget,
            bat,
                       
            {widget = mytextclock},
            {widget = s.mylayoutbox},
            layout = wibox.layout.fixed.horizontal,
        },
        
    }
end)


-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

-- {{{ Key bindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="Подсказки", group="awesome"}),
  -------------Перезапуск и выход
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "Перезагрузка awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "Выход из awesome", group = "awesome"}),
    awful.key({ altkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "Терминал", group = "launcher"}),
    awful.key({ altkey,           }, "s", function () awful.spawn(steam) end,
              {description = "Steam", group = "launcher"}),
    awful.key({ altkey,           }, "w", function () awful.spawn(browser) end,
              {description = "Браузер", group = "launcher"}),
    awful.key({ altkey,           }, "t", function () awful.spawn(telegram) end,
              {description = "Телеграм", group = "launcher"}),
    awful.key({ altkey,           }, "e", function () awful.spawn(exprorer) end,
              {description = "Проводник", group = "launcher"}),
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
})
-- Клавиши робочих столов
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "На робочий стол влево", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "На робочий стол вправо", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "К предыдущему рабочему столу", group = "tag"}),
})
-- Клавиши фокуса окон
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "Фокус к следующему окну", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "К предыдущему окну", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "К предыдущему активного окна", group = "client"}),
})

--Клавиши макета
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "Поменять с следующим окном", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "Поменять с предыдущим окном", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "Увеличить мастер онко", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "Уменьшить мастер окно", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "comma",    function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "Инкрементировать мастер окно", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "period",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "Декрементировать мастер окно", group = "layout"}),
    awful.key({ modkey,           }, "Up", function () awful.layout.inc( 1)                end,
              {description = "Следующая компоновка", group = "layout"}),
    awful.key({ modkey,           }, "Down", function () awful.layout.inc(-1)                end,
              {description = "Предыдущая компоновка", group = "layout"}),

              awful.key({}, "XF86AudioLowerVolume", function ()
                awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -3%", false) 
               -- update_volume_widget()
            end),
              awful.key({}, "XF86AudioRaiseVolume", function ()
                awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +3%", false) 
                --update_volume_widget()
            end),
              awful.key({}, "XF86AudioMute", function ()
                awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
                --update_volume_widget()
            end),
})

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                myscreen = awful.screen.focused()
                c:raise()
            end,
            {description = "Полноекранный режим", group = "client"}),
        awful.key({ modkey,           }, "c",      function (c) c:kill()                         end,
                {description = "Закрыть окно", group = "client"}),
        awful.key({ modkey,           }, "space",  awful.client.floating.toggle                     ,
                {description = "Перевод в плавающий режим", group = "client"}),
        awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "Поменять с мастер окном", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                c.minimized = true
            end ,
            {description = "Скрыть окно", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "Развернуть на полный екран", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "Сделать максимальным по вертикали", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "Сделать максимальным по горизонтали", group = "client"}),
    })
end)

ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }
    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer", "Telegram",
            },
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }
    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true      }
    }

end)

client.connect_signal("manage", function (c)
   if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)
client.connect_signal("property::floating", function(c)
    if not c.fullscreen then
        if c.floating then
            c.ontop = true
        else
            c.ontop = false
        end
    end
end)
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width -- your border width
        end
    end
end)

client.connect_signal("request::manage", function(client, context)

    if client.floating and context == "new" then
        client.placement = awful.placement.centered
    end
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)
--АВТОСТАРТ
awful.spawn.with_shell(
 
  'pkill setxkbmap;' ..
  'pkill picom;' ..
  'setxkbmap "us,ru,ua" -option "grp:alt_shift_toggle";' ..
  'picom --experimental-backends -b;' ..
  'xsetroot -cursor_name left_ptr' 
  
)




collectgarbage("incremental", 150, 600, 0)

gears.timer.start_new(60, function()
  -- just let it do a full collection
  collectgarbage()
  -- or else set a step size
  -- collectgarbage("step", 30000)
  return true
end)