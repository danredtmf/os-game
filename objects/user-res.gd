extends Node

class_name User

var id: int = 0
var user_name: String = ""
var login: String = ""
var password: String = ""

var settings: UserSettings = UserSettings.new()

func _to_string():
	var result = ("User_" + str(id) 
	+ ":\n	UserName: " + user_name 
	+ "\n	Login: " + login 
	+ "\n	Password: " + password 
	+ "\n	Settings.IsUnsafe: " + str(settings.is_unsafe) 
	+ "\n	Settings.IsHide: " + str(settings.is_hide))
	
	return result
