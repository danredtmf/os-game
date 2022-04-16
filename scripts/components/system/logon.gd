extends Control

const user_res = preload("res://objects/user-panel-select.tscn")

enum WIN_STATE {SELECT, LOGON}

onready var bg = $bg
onready var info = $info

onready var win_user_select = $win_user_select
onready var win_user_select_list = $win_user_select/margin/vb/scroll/margin/vb

onready var win_logon = $win_logon
onready var win_logon_back = $win_logon/margin/vb/hb_i/back
onready var win_logon_login = $win_logon/margin/vb/vb/login/edit
onready var win_logon_password = $win_logon/margin/vb/vb/pass/edit

onready var win_power = $win_power

onready var anim_wus = $anim_wus
onready var anim_logon = $anim_logon
onready var anim_power = $anim_power
onready var anim_bg = $anim_bg
onready var anim_info = $anim_info

var state = Core.LOGON_STATE.START
var win_state

func _ready():
	Data.active_user = null
# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "config")
	config()
	load_user_list()
	start()

func config():
	win_user_select.set_anchors_preset(Control.PRESET_CENTER, true)
	
	anim_wus.get_animation('show').track_set_key_value(0, 0, Vector2(win_user_select.rect_position.x, win_user_select.rect_position.y + 20))
	anim_wus.get_animation('show').track_set_key_value(0, 1, Vector2(win_user_select.rect_position.x, win_user_select.rect_position.y))
	
	anim_wus.get_animation('hide').track_set_key_value(0, 0, Vector2(win_user_select.rect_position.x, win_user_select.rect_position.y))
	anim_wus.get_animation('hide').track_set_key_value(0, 1, Vector2(win_user_select.rect_position.x, win_user_select.rect_position.y + 20))
	
	win_logon.set_anchors_preset(Control.PRESET_CENTER, true)
	
	anim_logon.get_animation('show').track_set_key_value(0, 0, Vector2(win_logon.rect_position.x, win_logon.rect_position.y + 20))
	anim_logon.get_animation('show').track_set_key_value(0, 1, Vector2(win_logon.rect_position.x, win_logon.rect_position.y))
	
	anim_logon.get_animation('hide').track_set_key_value(0, 0, Vector2(win_logon.rect_position.x, win_logon.rect_position.y))
	anim_logon.get_animation('hide').track_set_key_value(0, 1, Vector2(win_logon.rect_position.x, win_logon.rect_position.y + 20))

func start():
	info_state()

func load_user_list():
	var user_list = Data.get_user_list()
	
	for i in range(len(user_list)):
		var user_panel = user_res.instance()
		user_panel.get_node("margin/hb/select")\
			.connect("pressed", self, "on_select_user")
		user_panel.id = user_list[i].id
		user_panel.user_name = user_list[i].user_name
		win_user_select_list.add_child(user_panel)

func on_select_user():
	win_logon_back.visible = true
	
	if !anim_wus.is_playing():
		anim_wus.play("hide")
	win_state = WIN_STATE.LOGON

func info_state():
	var info_state = Core.INFO_STATE.ONE
	if !anim_bg.is_playing():
		anim_bg.play("show")
	
	if !anim_info.is_playing():
		anim_info.play("show")
	for _i in range(8):
		yield(get_tree().create_timer(0.5), "timeout")
		
		match info_state:
			Core.INFO_STATE.ONE:
				info_state = Core.INFO_STATE.TWO
			Core.INFO_STATE.TWO:
				info_state = Core.INFO_STATE.THREE
			Core.INFO_STATE.THREE:
				info_state = Core.INFO_STATE.FOUR
			Core.INFO_STATE.FOUR:
				info_state = Core.INFO_STATE.ONE
		
		match info_state:
			Core.INFO_STATE.ONE:
				info.text = ""
			Core.INFO_STATE.TWO:
				info.text = ""
			Core.INFO_STATE.THREE:
				info.text = ""
			Core.INFO_STATE.FOUR:
				info.text = ""
	
	if !anim_info.is_playing():
		anim_info.play("hide")

func info_login():
	state = Core.LOGON_STATE.LOGIN
	if !anim_bg.is_playing():
		anim_bg.play("hide")
	if !anim_power.is_playing():
		anim_power.play("hide")
	if !anim_info.is_playing():
		anim_info.play("show")
	info.text = 'Добро пожаловать, ' + Data.active_user.user_name + '!'

func _on_off_pressed():
	state = Core.LOGON_STATE.OFF
	win_state = null
	if !anim_bg.is_playing():
		anim_bg.play("hide")
	if !anim_wus.is_playing() && win_user_select.visible:
		anim_wus.play("hide")
	if !anim_logon.is_playing() && win_logon.visible:
		anim_logon.play("hide")
	if !anim_power.is_playing():
		anim_power.play("hide")

func _on_reload_pressed():
	state = Core.LOGON_STATE.RELOAD
	win_state = null
	if !anim_bg.is_playing():
		anim_bg.play("hide")
	if !anim_wus.is_playing() && win_user_select.visible:
		anim_wus.play("hide")
	if !anim_logon.is_playing() && win_logon.visible:
		anim_logon.play("hide")
	if !anim_power.is_playing():
		anim_power.play("hide")

func _on_back_pressed():
	Data.active_user = null
	win_state = WIN_STATE.SELECT
	if !anim_logon.is_playing():
		anim_logon.play("hide")

func _on_anim_info_animation_finished(anim_name):
	if anim_name == 'hide' && state == Core.LOGON_STATE.START:
		if Data.active_user == null && len(Data.users) > 2:
			win_logon_back.visible = true
			# Показать экран выбора пользователя
			if !anim_wus.is_playing():
				anim_wus.play("show")
			if !anim_power.is_playing():
				anim_power.play("show")
		# Когда Нет активного пользователя И пользователей 2
		elif Data.active_user == null && len(Data.users) == 2:
			win_logon_back.visible = false
			# Выбор не скрытого пользователя
			# (Он всегда второй, Админ всегда первый)
			Data.active_user = Data.users[len(Data.users) - 1]
			# Если пользователь без защиты
			if Data.active_user.settings.is_unsafe:
				# Вход в систему
				info_login()
			else:
				# Проверка защиты
				if !anim_logon.is_playing():
					anim_logon.play("show")
				if !anim_power.is_playing():
					anim_power.play("show")
	elif anim_name == 'hide' && state == Core.LOGON_STATE.LOGIN:
		yield(get_tree().create_timer(1), "timeout")
		var desktop = get_tree().change_scene_to(Core.desktop)
		if desktop == OK:
			print('////REBOOT-OS////')

func _on_anim_bg_animation_finished(anim_name):
	if anim_name == 'hide' && state == Core.LOGON_STATE.LOGIN:
		# Затухание info текста
		if !anim_info.is_playing():
			anim_info.play("hide")
	elif anim_name == 'hide' && state == Core.LOGON_STATE.RELOAD:
		yield(get_tree().create_timer(1), "timeout")
		var restart = get_tree().change_scene_to(Core.loading_res)
		if restart == OK:
			print('////REBOOT-OS////')
	elif anim_name == 'hide' && state == Core.LOGON_STATE.OFF:
		yield(get_tree().create_timer(1), "timeout")
		get_tree().quit()

func _on_anim_wus_animation_finished(anim_name):
	if anim_name == 'hide' && win_state == WIN_STATE.LOGON:
		if Data.active_user.settings.is_unsafe:
				# Вход в систему
				info_login()
		else:
			if !anim_logon.is_playing():
				anim_logon.play("show")

func _on_anim_logon_animation_finished(anim_name):
	if anim_name == 'hide' && win_state == WIN_STATE.SELECT:
		if !anim_wus.is_playing():
			anim_wus.play("show")

func _on_login_btn_pressed():
	if win_logon_login.text == Data.active_user.login\
	&& win_logon_password.text == Data.active_user.password:
		if !anim_logon.is_playing():
			anim_logon.play("hide")
		info_login()

