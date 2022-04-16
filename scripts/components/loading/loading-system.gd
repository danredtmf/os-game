extends Control

onready var info = $e/info

onready var anim_info = $c/anim_info

func _ready():
	Data.active_user = null
	Data.load_user()
	yield(get_tree().create_timer(1), "timeout")
	start()

func start():
	if !anim_info.is_playing():
		anim_info.play("show")
	
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
	
	if !anim_info.is_playing():
		anim_info.play("hide")

func init():
	if len(Data.users) > 1:
		var logon = get_tree().change_scene_to(Core.logon_res)
		if logon == OK:
			print('////LOGON////')
	else:
		var first_run = get_tree().change_scene_to(Core.first_run)
		if first_run == OK:
			print('////FIRST-RUN////')

func _on_anim_info_animation_finished(anim_name):
	if anim_name == 'hide':
		yield(get_tree().create_timer(1), "timeout")
		init()
