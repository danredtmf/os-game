extends Control

onready var desk_seconds = $Win/Margin/VB/DeskSeconds

func _ready() -> void:
	config()

func config() -> void:
	set_anchors_preset(Control.PRESET_WIDE)
	if !Data.active_user.settings.hide_seconds:
		desk_seconds.pressed = true
	else:
		desk_seconds.pressed = false

func _on_DeskSeconds_toggled(button_pressed: bool) -> void:
	Data.active_user.settings.hide_seconds = button_pressed
	Data.save_users()
