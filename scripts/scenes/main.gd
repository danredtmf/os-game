extends Control

onready var on_info = $e/on_info

var on_start = false

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			start()

func start():
	if !on_start:
		on_start = !on_start
		on_info.visible = false
		init()

func init():
	var loading = get_tree().change_scene_to(Core.loading_res) #Core.loading_res
	if loading == OK:
		print('////LOADING-OS////')
