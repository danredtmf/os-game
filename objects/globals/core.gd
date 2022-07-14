extends Node

enum INFO_STATE {ONE, TWO, THREE, FOUR}
enum LOGON_STATE {OFF, START, RELOAD, LOGIN}

func change_scene(scene_name: String, scene: PackedScene) -> void:
	var new_scene = get_tree().change_scene_to(scene)
	if new_scene == OK:
		print('////%s////' % [scene_name.to_upper()])

func get_desktop_datetime_string() -> String:
	var d = OS.get_datetime()
	var hour = "0%d" % [d["hour"]] if str(d["hour"]).length() < 2 \
		else "%d" % [d["hour"]]
	var minute = "0%d" % [d["minute"]] if str(d["minute"]).length() < 2 \
		else "%d" % [d["minute"]]
	var second = "0%d" % [d["second"]] if str(d["second"]).length() < 2 \
		else "%d" % [d["second"]]
	var day = "0%d" % [d["day"]] if str(d["day"]).length() < 2 \
		else "%d" % [d["day"]]
	var month = "0%d" % [d["month"]] if str(d["month"]).length() < 2 \
		else "%d" % [d["month"]]
	var year = "%d" % [d["year"]]
	
	return "%s:%s:%s\n%s.%s.%s" % \
	[hour, minute, second, day, month, year]
