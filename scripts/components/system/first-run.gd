extends Control

onready var bg = $e/bg
onready var info = $e/info

onready var win_name = $e/win_name
var win_name_rect_y
onready var edit_name = $e/win_name/margin/vb/name/edit
onready var btn_next_new_user = $e/win_name/margin/vb/next_new_user

onready var win_new_user = $e/win_new_user
var win_new_user_rect_y
onready var edit_login = $e/win_new_user/margin/vb/vb/login/edit
onready var edit_password = $e/win_new_user/margin/vb/vb/password/edit

onready var tween = $c/Tween
onready var tween2 = $c/Tween2

var on_win = false

func _ready():
	config()
	yield(get_tree().create_timer(1), "timeout")
	start()

func start():
	info_start()

func config():
	win_name.visible = false
	win_name.modulate.a = 0
	
	win_new_user.visible = false
	win_new_user.modulate.a = 0

func info_start():
	for i in range(3):
		match i:
			0:
				info.text = 'Привет'
			1:
				info.text = 'Сейчас будем настраивать систему'
			2:
				info.text = 'От вас требуются лишь информация'
				t_bg()
		
		t_info()
		yield(get_tree().create_timer(3), "timeout") #4
		t_info(false)
		yield(get_tree().create_timer(1), "timeout")

func info_end():
	t_win_new_user(false)
	yield(get_tree().create_timer(.25), "timeout")
	
	for i in range(3):
		match i:
			0:
				info.text = 'Сейчас будет создан ваш личный профиль'
			1:
				info.text = 'Нужно немного подождать'
			2:
				info.text = 'Почти готово'
				t_bg(false)
		
		t_info()
		yield(get_tree().create_timer(3), "timeout") #4
		t_info(false)
		yield(get_tree().create_timer(1), "timeout")

func t_win_new_user(b = true):
	if b:
		on_win = true
		win_new_user.visible = true
		
		tween2.interpolate_property(win_new_user, 'modulate:a', 0.0, 
		1.0, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween2.interpolate_property(win_new_user, 'rect_position:y', 
		164.5 + 20, 164.5, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween2.start()
	else:
		on_win = false
		
		tween2.interpolate_property(win_new_user, 'modulate:a', 1.0, 
		0.0, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween2.interpolate_property(win_new_user, 'rect_position:y', 
		164.5, 164.5 - 20, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween2.start()

func t_win_name(b = true):
	if b:
		on_win = true
		win_name.visible = true
		
		tween.interpolate_property(win_name, 'modulate:a', 0.0, 
		1.0, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.interpolate_property(win_name, 'rect_position:y', 
		226 + 20, 226, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.start()
	else:
		on_win = false
		
		tween.interpolate_property(win_name, 'modulate:a', 1.0, 
		0.0, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.interpolate_property(win_name, 'rect_position:y', 
		226, 226 - 20, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.start()

func t_info(b = true):
	if b:
		tween.interpolate_property(info, 'modulate:a', 0.0, 1.0, 1.0, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property(info, 'modulate:a', 1.0, 0.0, 1.0, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()

func t_bg(b = true):
	if b:
		tween2.interpolate_property(bg, 'color', Core.bg_black, 
		Core.bg_on, 4.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween2.start()
	else:
		tween2.interpolate_property(bg, 'color', Core.bg_on, 
		Core.bg_black, 4.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween2.start()

func _on_Tween_tween_completed(object, key):
	if object == win_name && key == ':modulate:a' \
	&& win_name.visible && !on_win:
		win_name.visible = false

func _on_Tween2_tween_completed(object, key):
	if object == bg && bg.color == Core.bg_on:
		yield(get_tree().create_timer(.5), "timeout")
		t_win_name()
	if object == bg && bg.color == Core.bg_black:
		yield(get_tree().create_timer(1), "timeout")
		var loading = get_tree().change_scene_to(Core.loading_res)
		if loading == OK:
			print('////LOADING-OS////')
	if object == win_new_user && key == ':modulate:a' \
	&& win_new_user.visible && !on_win:
		win_new_user.visible = false

func _on_next_new_user_pressed():
	if edit_name.text != '':
		t_win_name(false)
		yield(get_tree().create_timer(.25), "timeout")
		t_win_new_user()

func _on_back_name_pressed():
	t_win_new_user(false)
	yield(get_tree().create_timer(.25), "timeout")
	t_win_name()

func _on_next_reg_pressed():
	if edit_login.text == '' && edit_password.text == '':
		info_end()
		Data.create_user(edit_name.text)
	elif edit_login.text != '' && edit_password.text != '':
		info_end()
		Data.create_user(edit_name.text, edit_login.text, 
		edit_password.text, false)
