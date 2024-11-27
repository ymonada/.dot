-- Required libraries
local awful         = require("awful")
local naughty       = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local gfs           = require("gears.filesystem")
local themes_path   = gfs.get_themes_dir()

-- Default modkey.
-- Modkey: Mod4 (Super key) or Mod1 (Alt key)
local modkey        = "Mod4"
local altkey        = "Mod1"
local terminal = "alacritty"
local browser = "firefox"
local telegram = "telegram-desktop"
local exprorer = "nemo"
local volume = "pavucontrol"
local rofi = "rofi -show drun"
local discord = "discord"
local steam = "steam"
-- AwesomeWM
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
    awful.key({ modkey }, "Escape", function()
        awesome.emit_signal("module::powermenu:show")
    end, { description = "powermenu", group = "awesome" })
})
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "На робочий стол влево", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "На робочий стол вправо", group = "tag"}),
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


-- System
awful.keyboard.append_global_keybindings({
    awful.key({}, "XF86AudioRaiseVolume", function()
        awesome.emit_signal("volume::increase")
    end, { description = "raise volume", group = "control / media" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awesome.emit_signal("volume::decrease")
    end, { description = "lower volume", group = "control / media" }),
    awful.key({}, "XF86AudioMute", function()
        awesome.emit_signal("volume::mute")
    end, { description = "toggle volume", group = "control / media" }),
    awful.key({}, "XF86AudioMicMute", function()
        awesome.emit_signal("mic::toggle")
    end, { description = "toggle mic", group = "control / media" }),
    awful.key({}, "XF86AudioPlay", function()
        awful.spawn("playerctl play-pause", false)
    end, { description = "audio Play", group = "control / media" }),
    awful.key({}, "XF86AudioNext", function()
        awful.spawn("playerctl next", false)
    end, { description = "audio Next", group = "control / media" }),
    awful.key({}, "XF86AudioPrev", function()
        awful.spawn("playerctl previous", false)
    end, { description = "audio Prev", group = "control / media" }),
    awful.key({}, "XF86MonBrightnessUp", function()
        awesome.emit_signal("brightness::increase")
    end, { description = "brightness up", group = "control / media" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        awesome.emit_signal("brightness::decrease")
    end, { description = "brightness down", group = "control / media" }),
})

-- Layout
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