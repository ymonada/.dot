#!/bin/bash

# Предыдущая раскладка (начальное значение)
prev_layout=""

# Бесконечный цикл для отслеживания изменений раскладки
while true; do
    # Получение текущей раскладки
    current_layout=$(hyprctl devices | grep "active_keymap" | awk '{print $2}')

    # Проверка, изменилась ли раскладка
    if [ "$current_layout" != "$prev_layout" ]; then
        # Отправка уведомления о смене раскладки
        notify-send "Keyboard Layout Changed" "Current Layout: $current_layout" --icon=dialog-information
        
        # Обновление предыдущей раскладки
        prev_layout="$current_layout"
    fi

    # Ожидание перед следующей проверкой (например, 1 секунда)
    sleep 1
done