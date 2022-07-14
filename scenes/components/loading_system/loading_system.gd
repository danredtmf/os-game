extends Control

func _ready():
	Data.active_user = null
	Data.load_user()
	yield(get_tree().create_timer(1), "timeout")
	start()

func start():
	if !$Animation.is_playing():
		$Animation.play("show")
	
	var str_info = $Info.text
	
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
				$Info.text = text
			Core.INFO_STATE.TWO:
				$Info.text = text + "."
			Core.INFO_STATE.THREE:
				$Info.text = text + ".."
			Core.INFO_STATE.FOUR:
				$Info.text = text + "..."
	
	if !$Animation.is_playing():
		$Animation.play("hide")

func init():
	if len(Data.users) > 1:
		Core.change_scene("logon", GlobalReference.logon)
	else:
		Core.change_scene("first-run", GlobalReference.first_run)

func _on_anim_info_animation_finished(anim_name):
	if anim_name == 'hide':
		yield(get_tree().create_timer(1), "timeout")
		init()
