extends Control

onready var m_taskbar = $margin_taskbar
onready var taskbar = $margin_taskbar/tb
onready var datetime = $margin_taskbar/tb/margin/hb/DateTime

func _ready() -> void:
	datetime.text = get_datetime_string()

func _on_ch_user_btn_pressed():
	$anim_menu.play("hide")
	
	$margin_taskbar/tb/margin/hb/m_menu/menu.pressed = false
	yield(get_tree().create_timer(1), "timeout")
	var logon = get_tree().change_scene_to(Core.logon_res)
	if logon == OK:
		print('////LOGON////')

func _on_reload_btn_pressed():
	$anim_menu.play("hide")
		
	$margin_taskbar/tb/margin/hb/m_menu/menu.pressed = false
	yield(get_tree().create_timer(1), "timeout")
	var loading = get_tree().change_scene_to(Core.loading_res)
	if loading == OK:
		print('////LOADING-OS////')

func _on_off_btn_pressed():
	$anim_menu.play("hide")
	
	$margin_taskbar/tb/margin/hb/m_menu/menu.pressed = false
	yield(get_tree().create_timer(1), "timeout")
	get_tree().quit()

func _on_menu_toggled(button_pressed):
	if button_pressed:
		$anim_menu.play("show")
	else:
		$anim_menu.play("hide")

func get_datetime_string() -> String:
	var d = OS.get_datetime()
	var hour = "0%d" % [d["hour"]] if str(d["hour"]).length() < 2 \
		else "%d" % [d["hour"]]
	var minute = "0%d" % [d["minute"]] if str(d["minute"]).length() < 2 \
		else "%d" % [d["minute"]]
	var second = "0%d" % [d["second"]] if str(d["second"]).length() < 2 \
		else "%d" % [d["second"]]
	var day = "0%d" % [d["day"]] if str(d["day"]).length() < 2 \
		else "%d" % [d["day"]]
	var month = "0%d" % [d["month"]] if str(d["month"]).length() < 2 \
		else "%d" % [d["month"]]
	var year = "%d" % [d["year"]]
	
	return "%s:%s:%s\n%s.%s.%s" % \
	[hour, minute, second, day, month, year]

func _on_TimeTimer_timeout() -> void:
	datetime.text = get_datetime_string()

