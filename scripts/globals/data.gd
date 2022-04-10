extends Node

const USERS_PATH = 'user://users.data'

var _new_user = {
	"id": null,
	"name": "",
	"login": null,
	"password": null,
	"settings": {
		"is_unsafe": null,
		"is_hide": false,
	}
}

var users = []

var active_user = {
	"id": null,
	"name": "",
	"login": "",
	"password": "",
	"settings": {
		"is_unsafe": null,
		"is_hide": false,
	}
}

func create_admin():
	var u = _new_user.duplicate()
	u['id'] = 0
	u['name'] = "Admin"
	u['login'] = "admin"
	u['password'] = "admin"
	u['settings']['is_unsafe'] = false
	u['settings']['is_hide'] = true
	users.append(u)
	
	Data.save_users()

func create_user(name: String, login = null, 
				password = null, is_unsafe: bool = true):
	var u = _new_user.duplicate()
	u['id'] = len(users)
	u['name'] = name
	u['login'] = login
	u['password'] = password
	u['settings']['is_unsafe'] = is_unsafe
	u['settings']['is_hide'] = false
	print(u)
	users.append(u)
	
	Data.save_users()

func save_users():
	var file = File.new()
	file.open(USERS_PATH, File.WRITE)
	file.store_string(to_json(users))
	file.close()

func load_user():
	var file = File.new()
	if file.file_exists(USERS_PATH):
		file.open(USERS_PATH, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_ARRAY:
			users = data
			print("////SUCCESSFUL USER UPLOAD!////")
		else:
			print("////CORRUPTED DATA!////")
	else:
		print("////NO DATA! ADMINISTRATOR CREATION...////")
		
		create_admin()
	
	for i in range(len(users)):
		print(users[i])
