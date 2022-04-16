extends Control

onready var m_taskbar = $margin_taskbar
onready var taskbar = $margin_taskbar/tb

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
