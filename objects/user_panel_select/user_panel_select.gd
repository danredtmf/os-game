extends PanelContainer

var id
export var user_name = ''

onready var user = $Margin/HB/Name

func _ready():
	user.text = user_name

func _on_Select_pressed():
	Data.select_user(id)
