#!/bin/bash

# Получите текущий язык
lang=$(localectl status | grep "LANG" | awk '{print $2}')

# Создайте сообщение уведомления
message="Язык системы изменен на: $lang"

# Отправьте уведомление
makoctl -t "Смена языка" -m "$message"