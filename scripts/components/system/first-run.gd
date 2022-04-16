extends Control

enum STATE {START, NAME, NEW_USER, READY}

onready var bg = $bg
onready var info = $info

onready var win_name = $win_name
onready var edit_name = $win_name/margin/vb/name/edit
onready var btn_next_new_user = $win_name/margin/vb/next_new_user

onready var win_new_user = $win_new_user
onready var edit_login = $win_new_user/margin/vb/vb/login/edit
onready var edit_password = $win_new_user/margin/vb/vb/password/edit

onready var anim_bg = $anim_bg
onready var anim_info = $anim_info
onready var anim_wn = $anim_wn
onready var anim_wnu = $anim_wnu

var state = STATE.START
var info_state = Core.INFO_STATE.ONE

func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "config")
	config()
	yield(get_tree().create_timer(1), "timeout")
	start()

func start():
	info_start()

func config():
	win_name.set_anchors_preset(Control.PRESET_CENTER, true)
	
	anim_wn.get_animation('show').track_set_key_value(0, 0, Vector2(win_name.rect_position.x, win_name.rect_position.y + 20))
	anim_wn.get_animation('show').track_set_key_value(0, 1, Vector2(win_name.rect_position.x, win_name.rect_position.y))
	
	anim_wn.get_animation('hide').track_set_key_value(0, 0, Vector2(win_name.rect_position.x, win_name.rect_position.y))
	anim_wn.get_animation('hide').track_set_key_value(0, 1, Vector2(win_name.rect_position.x, win_name.rect_position.y + 20))
	
	win_new_user.set_anchors_preset(Control.PRESET_CENTER, true)
	
	anim_wnu.get_animation('show').track_set_key_value(0, 0, Vector2(win_new_user.rect_position.x, win_new_user.rect_position.y + 20))
	anim_wnu.get_animation('show').track_set_key_value(0, 1, Vector2(win_new_user.rect_position.x, win_new_user.rect_position.y))
	
	anim_wnu.get_animation('hide').track_set_key_value(0, 0, Vector2(win_new_user.rect_position.x, win_new_user.rect_position.y))
	anim_wnu.get_animation('hide').track_set_key_value(0, 1, Vector2(win_new_user.rect_position.x, win_new_user.rect_position.y + 20))

func info_start():
	match info_state:
		Core.INFO_STATE.ONE:
			info.text = 'Привет'
		Core.INFO_STATE.TWO:
			info.text = 'Сейчас будем настраивать систему'
		Core.INFO_STATE.THREE:
			info.text = 'Поможете?'
			if !anim_bg.is_playing():
				anim_bg.play("show")
		
	if !anim_info.is_playing():
		anim_info.play("show")

func info_end():
	match info_state:
		Core.INFO_STATE.ONE:
			info.text = 'Сейчас будет создан ваш личный профиль'
		Core.INFO_STATE.TWO:
			info.text = 'Нужно немного подождать'
		Core.INFO_STATE.THREE:
			info.text = 'Почти готово'
			if !anim_bg.is_playing():
				anim_bg.play("hide")
		
	if !anim_info.is_playing():
		anim_info.play("show")

func _on_next_new_user_pressed():
	if edit_name.text != '':
		state = STATE.NEW_USER
		if !anim_wn.is_playing():
			anim_wn.play("hide")

func _on_back_name_pressed():
	state = STATE.NAME
	if !anim_wnu.is_playing():
		anim_wnu.play("hide")

func _on_next_reg_pressed():
	if edit_login.text == '' && edit_password.text == '':
		info_state = Core.INFO_STATE.ONE
		state = STATE.READY
	
		if !anim_wnu.is_playing():
			anim_wnu.play("hide")
		
		Data.create_user(edit_name.text)
	elif edit_login.text != '' && edit_password.text != '':
		info_state = Core.INFO_STATE.ONE
		state = STATE.READY
	
		if !anim_wnu.is_playing():
			anim_wnu.play("hide")
		
		Data.create_user(edit_name.text, edit_login.text, 
		edit_password.text, false)

func _on_anim_info_animation_finished(anim_name):
	if anim_name == 'show' && state == STATE.START:
		yield(get_tree().create_timer(3), "timeout")
		if !anim_info.is_playing():
			anim_info.play("hide")
	elif anim_name == 'show' && state == STATE.READY:
		yield(get_tree().create_timer(3), "timeout")
		if !anim_info.is_playing():
			anim_info.play("hide")
	elif anim_name == 'hide' && state == STATE.START:
		if info_state == Core.INFO_STATE.ONE:
			info_state = Core.INFO_STATE.TWO
			yield(get_tree().create_timer(1), "timeout")
			info_start()
		elif info_state == Core.INFO_STATE.TWO:
			info_state = Core.INFO_STATE.THREE
			yield(get_tree().create_timer(1), "timeout")
			info_start()
		elif info_state == Core.INFO_STATE.THREE:
			yield(get_tree().create_timer(1), "timeout")
			state = STATE.NAME
			if !anim_wn.is_playing():
				anim_wn.play("show")
	elif anim_name == 'hide' && state == STATE.READY:
		if info_state == Core.INFO_STATE.ONE:
			info_state = Core.INFO_STATE.TWO
			yield(get_tree().create_timer(1), "timeout")
			info_end()
		elif info_state == Core.INFO_STATE.TWO:
			info_state = Core.INFO_STATE.THREE
			yield(get_tree().create_timer(1), "timeout")
			info_end()
		elif info_state == Core.INFO_STATE.THREE:
			yield(get_tree().create_timer(1), "timeout")
			var loading = get_tree().change_scene_to(Core.loading_res)
			if loading == OK:
				print('////LOADING-OS////')

func _on_anim_wnu_animation_finished(anim_name):
	if anim_name == 'hide' && state == STATE.NAME:
		if !anim_wn.is_playing():
			anim_wn.play("show")
	elif anim_name == 'hide' && state == STATE.READY:
		info_end()

func _on_anim_wn_animation_finished(anim_name):
	if anim_name == 'hide' && state == STATE.NEW_USER:
		if !anim_wnu.is_playing():
			anim_wnu.play("show")

func _on_anim_bg_animation_finished(anim_name):
	if anim_name == 'hide' && state == STATE.READY:
		if info_state == Core.INFO_STATE.THREE:
			if !anim_info.is_playing():
				anim_info.play("hide")
