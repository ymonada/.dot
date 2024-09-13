local awful = require("awful")
local wibox = require("wibox")

-- Создаем виджет
local battery_widget = wibox.widget.textbox()

-- Функция для обновления состояния батареи
local function update_battery()
    awful.spawn.easy_async("acpi -b", function(stdout, stderr, reason, exit_code)
        local battery_info = stdout:match("Battery %d: (%a+), (%d+)%%")
        
        if battery_info then
            local status, charge = stdout:match("Battery %d: (%a+), (%d+)%%")
            local symbol = ""
            local color = "<span>"
            if status == "Charging" then
                symbol = "󰂄"
            elseif status == "Full" then
                symbol = "󰁹"
            elseif charge < 11 then
                color = "<span color='red'>"
                symbol = "󰁺"
            elseif charge < 21 then
                color = "<span color='red'>"
                symbol = "󰁻"
            elseif charge < 31 then
                symbol = "󰁼"
            elseif charge < 41 then
                symbol = "󰁽"
            elseif charge < 51 then
                symbol = "󰁾"
            elseif charge < 61 then
                symbol = "󰁿"
            elseif charge < 71 then
                symbol = "󰂀"
            elseif charge < 81 then
                symbol = "󰂁"
            elseif charge < 91 then
                symbol = "󰂂"
            else 
                symbol = "󰁹"

            end
            
            battery_widget:set_markup(color .. symbol .. ' ' .. charge .. "%" .. " " .. "</span>")
        else
            battery_widget:set_text(" Бат: N/A ")
        end
    end)
end

-- Обновление каждые 60 секунд
local battery_timer = timer({ timeout = 60 })
battery_timer:connect_signal("timeout", update_battery)
battery_timer:start()

-- Начальное обновление
update_battery()

-- Добавьте этот виджет в вашу панель wibox
-- Например: s.mywibox:setup { ..., battery_widget, ... }

return battery_widget