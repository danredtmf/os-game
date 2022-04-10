extends Control

onready var info = $e/info

var on_start = false

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			start()

func start():
	if !on_start:
		on_start = !on_start
		info.visible = false
		init()

func init():
	var loading = get_tree().change_scene_to(Core.loading_res)
	if loading == OK:
		print('////LOADING-OS////')
