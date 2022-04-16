extends PanelContainer

var id
export var user_name = ''

func _ready():
	$margin/hb/name.text = user_name

func _on_select_pressed():
	Data.select_user(id)
