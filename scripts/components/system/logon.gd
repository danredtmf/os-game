extends Control

const user_res = preload("res://objects/user-panel-select.tscn")

onready var bg = $e/bg
onready var info = $e/info
onready var on = $e

onready var win_user_select = $e/win_user_select
onready var win_user_select_list = \
			$e/win_user_select/margin/vb/scroll/margin/vb
var win_user_select_rect_y

onready var win_logon = $e/win_logon
var win_logon_rect_y

onready var win_power = $e/win_power

onready var tween = $c/Tween
onready var tween2 = $c/Tween2
onready var tween3 = $c/Tween3

var on_start = true
var on_restart = false
var on_login = false

func _ready():
	config()
	load_user_list()
	yield(get_tree().create_timer(1), "timeout")
	start()

func config():
	win_user_select.visible = false
	win_user_select.modulate.a = 0
	win_user_select.set_anchors_preset(Control.PRESET_CENTER)
	win_user_select_rect_y = win_user_select.rect_position.y
	
	win_logon.visible = false
	win_logon.modulate.a = 0
	win_logon.set_anchors_preset(Control.PRESET_CENTER)
	win_logon_rect_y = win_logon.rect_position.y
	
	win_power.visible = false
	win_power.modulate.a = 0
	
	info.modulate.a = 0

func start():
	info_state()

func load_user_list():
	var user_list = Data.get_user_list()
	
	# Дописать добавление списка пользователей
	
	for i in range(len(user_list)):
		print_debug(user_list[i].to_string())
		var user_panel = user_res.instance()
		user_panel.id = user_list[i].id
		user_panel.user_name = user_list[i].user_name
		win_user_select_list.add_child(user_panel)

func info_state():
	var state = Core.INFO_STATE.ONE
	t_color(bg, Core.bg_black, Core.bg_on, 4)
	
	t3_modulate_a(info, 0, 1, 1)
	for _i in range(8):
		yield(get_tree().create_timer(0.5), "timeout")
		
		match state:
			Core.INFO_STATE.ONE:
				state = Core.INFO_STATE.TWO
			Core.INFO_STATE.TWO:
				state = Core.INFO_STATE.THREE
			Core.INFO_STATE.THREE:
				state = Core.INFO_STATE.FOUR
			Core.INFO_STATE.FOUR:
				state = Core.INFO_STATE.ONE
		
		match state:
			Core.INFO_STATE.ONE:
				info.text = ""
			Core.INFO_STATE.TWO:
				info.text = "."
			Core.INFO_STATE.THREE:
				info.text = ".."
			Core.INFO_STATE.FOUR:
				info.text = "..."
	t3_modulate_a(info, 1, 0, 1)

func t_info(b = true):
	if b:
		info.visible = true
		tween3.interpolate_property(info, 'modulate:a', 0.0, 1.0, 1.0, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween3.start()
	else:
		tween3.interpolate_property(info, 'modulate:a', 1.0, 0.0, 1.0, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween3.start()

func t_win_logon(b = true):
	if b:
		win_logon.visible = true
		win_power.visible = true
		
		tween.interpolate_property(win_logon, 'modulate:a', 0.0, 
		1.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(win_logon, 'rect_position:y', 
		win_logon_rect_y + 20, win_logon_rect_y, 
		0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		
		tween2.interpolate_property(win_power, 'modulate:a', 0.0, 
		1.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween2.start()
	else:
		tween.interpolate_property(win_logon, 'modulate:a', 1.0, 
		0.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(win_logon, 'rect_position:y', 
		win_logon_rect_y, win_logon_rect_y + 20, 
		0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		
		tween2.interpolate_property(win_power, 'modulate:a', 1.0, 
		0.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween2.start()

func t3_modulate_a(object: Object, init: float, end: float, time: float):
	tween3.interpolate_property(object, 'modulate:a', init, end, time, 
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween3.start()

func t_color(object: Object, init_color: Color, end_color: Color, time: float):
	tween.interpolate_property(object, 'color', init_color, 
	end_color, time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func info_login():
	t_color(bg, Core.bg_on, Core.bg_black, 4)
	t3_modulate_a(info, 0, 1, 1)
	info.text = 'Добро пожаловать, ' + Data.active_user.user_name + '!'
	yield(get_tree().create_timer(2), "timeout")
	on_login = true

func t_bg(b = true):
	if b:
		tween.interpolate_property(bg, 'color', Core.bg_black, 
		Core.bg_on, 4.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property(bg, 'color', Core.bg_on, 
		Core.bg_black, 4.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()

func _on_Tween_tween_completed(object, _key):
	# Когда синий экран
	if object == bg && bg.color == Core.bg_on:
		# Если Нет активного пользователя И пользователей > 2
		if Data.active_user == null && len(Data.users) > 2:
			# Показать экран выбора пользователя
			yield(get_tree().create_timer(1), "timeout")
			t_win_logon() # Заменить на экран выбора пользователя
		# Когда Нет активного пользователя И пользователей 2
		elif Data.active_user == null && len(Data.users) == 2:
			# Выбор не скрытого пользователя
			# (Он всегда второй, Админ всегда первый)
			Data.active_user = Data.users[len(Data.users) - 1]
			yield(get_tree().create_timer(1), "timeout")
			# Если пользователь без защиты
			if Data.active_user.settings.is_unsafe:
				# Вход в систему
				info_login()
			else:
				# Проверка защиты
				t_win_logon()
	# Когда чёрный экран
	elif object == bg && bg.color == Core.bg_black:
		# Затухание info текста
		t3_modulate_a(info, 1, 0, 1)
	# Когда потух Проверка защиты но ещё виден в дереве
	elif object == win_logon && win_logon.modulate.a == 0 \
	&& win_logon.visible == true:
		# Скрыть, чтобы случайно не тронуть невидимку
		win_logon.visible = false

func _on_off_pressed():
	on_start = !on_start
	t_color(bg, Core.bg_on, Core.bg_black, 4)
	t_win_logon(false)

func _on_Tween2_tween_completed(object, _key):
	if object == win_power && win_power.modulate.a == 0 \
	&& win_power.visible == true:
		win_power.visible = false

func _on_reload_pressed():
	on_start = !on_start
	on_restart = !on_restart
	t_color(bg, Core.bg_on, Core.bg_black, 4)
	t_win_logon(false)

func _on_Tween3_tween_completed(_object, _key):
	if !on_start && !on_restart && !on_login:
		get_tree().quit()
	if !on_start && on_restart && !on_login:
		var restart = get_tree().change_scene("res://scenes/main.tscn")
		if restart == OK:
			print('////REBOOT-OS////')
	if on_start && !on_restart && on_login:
		get_tree().quit()

