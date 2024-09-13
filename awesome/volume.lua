-- Зависимости
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Функция для получения текущей громкости
local function get_volume()
    local fd = io.popen("pactl get-sink-volume @DEFAULT_SINK@")
    local status = fd:read("*all")
    fd:close()

    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = tonumber(volume) or 0  -- Устанавливаем 0, если volume равен nil

    fd = io.popen("pactl get-sink-mute @DEFAULT_SINK@")
    local mute_status = fd:read("*all")
    fd:close()

    local mute = string.match(mute_status, "Mute: (%w+)")
    if mute == "yes" then
        return volume, true
    else
        return volume, false
    end
end

-- Виджет звука
local volume_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.textbox,
        text = "",
        font = "JetBrainsMono Nerd 18",
    },
    {
        id = "volume_level",
        widget = wibox.widget.textbox,
        text = "0%",
    },
    layout = wibox.layout.align.horizontal,
}

-- Обновление виджета
local function update_volume_widget()
    local volume, mute = get_volume()
    if mute then
        volume_widget.icon.text = "󰖁 "
    else
        if volume <= 30 then
            volume_widget.icon.text = "󰕿 "
        elseif volume < 60 then
            volume_widget.icon.text = "󰖀 "
        else
            volume_widget.icon.text = "󰕾 "
        end
    end
    volume_widget.volume_level.text = '' .. volume .. "%"
end

-- Таймер для обновления виджета
gears.timer {
    timeout = 0,
    autostart = true,
    call_now = true,
    callback = update_volume_widget,
}

-- Управление звуком по клику
volume_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then -- Левый клик
        awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
    elseif button == 4 then -- Колесо вверх
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +3%", false)
    elseif button == 5 then -- Колесо вниз
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -3%", false)
    end
    update_volume_widget()
end)

-- Возвращаем виджет
return volume_widget