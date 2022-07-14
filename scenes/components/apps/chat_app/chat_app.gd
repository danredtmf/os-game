extends Control

onready var chats_dialogs = $Win/Margin/VB/HB/HS/Chats/Margin/VB/Items
onready var message = $Win/Margin/VB/HB/HS/Message/Margin

var is_move = false

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$Animation.play("show")
	Data.load_user()
	Data.active_user = Data.users[0]

func test_chat_dialog():
	var d = ChatDialog.new()
	d.id = 12
	d.sender_name = 'Мистерио'
	
	var m = ChatDialogMessage.new()
	m.message = 'Приветствую тебя!'
	d.messages.append(m)
	
	Data.active_user.apps.chat.dialogs.append(d)
	Data.save_users()
	
	var ld = Label.new()
	ld.text = Data.active_user.apps.chat.dialogs[0].sender_name
	
	var lm = Label.new()
	lm.text = Data.active_user.apps.chat.dialogs[0].messages[0].message
	
	chats_dialogs.add_child(ld)
	message.add_child(lm)

func _on_Info_mouse_entered():
	is_move = true

func _on_Info_mouse_exited():
	is_move = false

func _input(event):
	if event is InputEventMouseMotion:
		if is_move && event.pressure:
			rect_position = rect_position + event.relative

func _on_Close_pressed():
	$Animation.play("hide")

func _on_Animation_finished(anim_name):
	if anim_name == 'hide':
		queue_free()
