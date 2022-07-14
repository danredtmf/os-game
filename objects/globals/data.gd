extends Node

const USERS_PATH = 'user://users.data'

var users: Array = []
var active_user: User

func select_user(id):
	active_user = users[id]

func get_user_list():
	var user_list = []
	for i in range(len(users)):
		if users[i].settings.is_hide == false:
			var u = users[i]
			user_list.append(u)
	return user_list

func create_admin():
	var u = User.new()
	u.id = 0
	u.user_name = "Admin"
	u.login = "admin"
	u.password = "admin"
	u.settings.is_unsafe = false
	u.settings.is_hide = true
	users.append(u)
	
	Data.save_users()

func create_user(name: String, login: String = "", 
				password: String = "", is_unsafe: bool = true):
	var u = User.new()
	u.id = len(users)
	u.user_name = name
	u.login = login
	u.password = password
	u.settings.is_unsafe = is_unsafe
	u.settings.is_hide = false
	users.append(u)
	
	Data.save_users()

func save_users():
	var c = ConfigFile.new()
	c.set_value("users", "users", users)
	c.save(USERS_PATH)

func load_user():
	var c = ConfigFile.new()
	var l = c.load(USERS_PATH)
	if l == ERR_FILE_NOT_FOUND:
		print("////NO DATA! ADMINISTRATOR CREATION...////")
		create_admin()
	elif l == OK:
		users = c.get_value("users", "users")
		print("////SUCCESSFUL USER UPLOAD!////")
