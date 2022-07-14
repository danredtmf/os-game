extends Node

# Сцены
# - Загрузка ОС
const loading_system = preload('res://scenes/components/loading_system/loading_system.tscn')
# - Настройка ОС
const first_run = preload('res://scenes/components/system/first_run/first_run.tscn')
# - Вход
const logon = preload('res://scenes/components/system/logon/logon.tscn')
# - Рабочий стол
const desktop = preload('res://scenes/components/system/desktop/desktop.tscn')

# Цвета
const bg_black = Color(0, 0, 0, 1)
const bg_blue = Color(0.21, 0.55, 0.99, 1)
