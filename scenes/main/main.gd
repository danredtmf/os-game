extends Control

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			start()

func start():
	$Info.visible = false
	init()

func init():
	Core.change_scene("loading-system", GlobalReference.loading_system)
