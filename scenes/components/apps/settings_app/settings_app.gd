extends Control

const desk_win_res = preload('res://scenes/components/apps/settings_app/seconadary/desk_win/desk_win.tscn')

var is_move = false

onready var win_place = $Win/Margin/VB/HB/HS/TabWin/Margin

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$Animation.play("show")
	Data.load_user()
	Data.active_user = Data.users[1]

func _on_info_mouse_entered():
	is_move = true

func _on_info_mouse_exited():
	is_move = false

func _input(event):
	if event is InputEventMouseMotion:
		if is_move && event.pressure:
			rect_position = rect_position + event.relative

func _on_close_pressed():
	$Animation.play("hide")

func _on_Animation_finished(anim_name):
	if anim_name == 'hide':
		queue_free()

func delete_win() -> void:
	if win_place.get_child_count() > 0:
		win_place.get_children()[0].queue_free()

func _on_Desk_toggled(button_pressed: bool) -> void:
	if button_pressed:
		delete_win()
		var desk_win = desk_win_res.instance()
		win_place.add_child(desk_win)
	else:
		delete_win()
