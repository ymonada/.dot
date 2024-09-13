-- Зависимости
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Функция для получения загрузки процессора
local function get_cpu_load()
    local fd = io.popen("top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'")
    local status = fd:read("*all")
    fd:close()

    local load = tonumber(status) or 0
    return string.format("%.1f%%", load)
end

-- Виджет загрузки процессора
local cpu_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.textbox,
        text = "󰍛 ",
    },
    {
        id = "cpu_load",
        widget = wibox.widget.textbox,
        text = "0%",
    },
    layout = wibox.layout.align.horizontal,
}

-- Обновление виджета
local function update_cpu_widget()
    local load = get_cpu_load()
    cpu_widget.cpu_load.text = load
end

-- Таймер для обновления виджета
gears.timer {
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = update_cpu_widget,
}

-- Возвращаем виджет
return cpu_widget