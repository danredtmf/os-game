extends Control

onready var chats_dialogs = $win/margin/vbox/hb/hs/chats/margin/vb/items
onready var message = $win/margin/vbox/hb/hs/message/margin

var is_move = false

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$anim.play("show")
	Data.load_user()
	Data.active_user = Data.users[0]
	
#	var d = ChatDialog.new()
#	d.id = 12
#	d.sender_name = 'Мистерио'
#
#	var m = ChatDialogMessage.new()
#	m.message = 'Приветствую тебя!'
#
#	d.messages.append(m)
#
#	Data.active_user.apps.chat.dialogs.append(d)
#
#	Data.save_users()
#
#	var ld = Label.new()
#	ld.text = Data.active_user.apps.chat.dialogs[0].sender_name
#
#	var lm = Label.new()
#	lm.text = Data.active_user.apps.chat.dialogs[0].messages[0].message
#
#	chats_dialogs.add_child(ld)
#	message.add_child(lm)

func _on_info_mouse_entered():
	is_move = true

func _on_info_mouse_exited():
	is_move = false

func _input(event):
	if event is InputEventMouseMotion:
		if is_move && event.pressure:
			rect_position = rect_position + event.relative

func _on_close_pressed():
	$anim.play("hide")

func _on_anim_animation_finished(anim_name):
	if anim_name == 'hide':
		queue_free()
