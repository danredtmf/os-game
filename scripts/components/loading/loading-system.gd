extends Control

onready var loading = $e/loading
onready var info = $e/loading/info

onready var tween = $c/Tween

func _ready():
	Data.active_user = null
	Data.load_user()
	yield(get_tree().create_timer(1), "timeout")
	start()

func start():
	t_info()
	yield(get_tree().create_timer(1), "timeout")
	var str_info = info.text
	
	info_state(str_info)

func info_state(text):
	var state = Core.INFO_STATE.ONE
	
	for _i in range(4):
		yield(get_tree().create_timer(1), "timeout")
		
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
				info.text = text
			Core.INFO_STATE.TWO:
				info.text = text + "."
			Core.INFO_STATE.THREE:
				info.text = text + ".."
			Core.INFO_STATE.FOUR:
				info.text = text + "..."
	
	t_info(false)

func t_info(b = true):
	if b:
		tween.interpolate_property(info, 'modulate:a', 0.0, 1.0, 1.0, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property(info, 'modulate:a', 1.0, 0.0, 1.0, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()

func init():
	if len(Data.users) > 1:
		var logon = get_tree().change_scene_to(Core.logon_res)
		if logon == OK:
			print('////LOGON////')
	else:
		var first_run = get_tree().change_scene_to(Core.first_run)
		if first_run == OK:
			print('////FIRST-RUN////')

func _on_Tween_tween_completed(object, _key):
	if object == info && info.modulate.a == 0:
		yield(get_tree().create_timer(1), "timeout")
		init()
