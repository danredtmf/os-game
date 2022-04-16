extends Node

const loading_res = preload("res://scenes/components/loading/loading-system.tscn")
const first_run = preload("res://scenes/components/system/first-run.tscn")
const logon_res = preload("res://scenes/components/system/logon.tscn")
const desktop = preload("res://scenes/components/system/desktop.tscn")

const bg_black = Color(0, 0, 0, 1)
const bg_blue = Color(0.21, 0.55, 0.99, 1)

enum INFO_STATE {ONE, TWO, THREE, FOUR}
enum LOGON_STATE {OFF, START, RELOAD, LOGIN}
