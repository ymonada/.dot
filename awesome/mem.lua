-- Зависимости
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Функция для получения использованной памяти
local function get_memory_usage()
    local fd = io.popen("free -h | grep 'Mem:'")
    local status = fd:read("*all")
    fd:close()

    local total, used, free = status:match("Mem:%s+(%S+)%s+(%S+)%s+(%S+)")
    return used
end

-- Виджет памяти
local memory_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.textbox,
        text = " 󰖆 ",
    },
    {
        id = "memory_usage",
        widget = wibox.widget.textbox,
        text = "0B",
    },
    layout = wibox.layout.align.horizontal,
}

-- Обновление виджета
local function update_memory_widget()
    local used = get_memory_usage()
    memory_widget.memory_usage.text = used .. "  "
end

-- Таймер для обновления виджета
gears.timer {
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = update_memory_widget,
}

-- Возвращаем виджет
return memory_widget