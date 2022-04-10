extends PanelContainer

var id
var user_name

func _on_select_pressed():
	Data.select_user(id)
