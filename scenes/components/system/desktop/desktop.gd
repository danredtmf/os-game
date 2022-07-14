extends Control

onready var m_taskbar = $MarginTaskbar
onready var taskbar = $MarginTaskbar/TB
onready var datetime = $MarginTaskbar/TB/Margin/HB/DateTime

onready var menu = $MarginTaskbar/TB/Margin/HB/Margin/Menu

func _ready() -> void:
	datetime.text = Core.get_desktop_datetime_string()

func _on_Exit_pressed():
	$AnimationMenu.play("hide")
	
	menu.pressed = false
	yield(get_tree().create_timer(1), "timeout")
	Core.change_scene("logon", GlobalReference.logon)

func _on_Reload_pressed():
	$AnimationMenu.play("hide")
	
	menu.pressed = false
	yield(get_tree().create_timer(1), "timeout")
	Core.change_scene("loading-system", GlobalReference.loading_system)

func _on_Off_pressed():
	$AnimationMenu.play("hide")
	
	menu.pressed = false
	yield(get_tree().create_timer(1), "timeout")
	get_tree().quit()

func _on_menu_toggled(button_pressed):
	if button_pressed:
		$AnimationMenu.play("show")
	else:
		$AnimationMenu.play("hide")

func _on_TimeTimer_timeout() -> void:
	datetime.text = Core.get_desktop_datetime_string()
