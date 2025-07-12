class_name GameManager
extends Node

signal added_colors(c: int, m: int, y: int)

const MAX_COLOR_VALUE = 4

@export_category("Color requirement")
@export_range(0, GameManager.MAX_COLOR_VALUE) var need_cyan: int
@export_range(0, GameManager.MAX_COLOR_VALUE) var need_magenta: int
@export_range(0, GameManager.MAX_COLOR_VALUE) var need_yellow: int

var cyan: int = 0
var magenta: int = 0
var yellow: int = 0


## Do not use global magic strings.
## Prefer this method over %GameManger.
static func get_instance() -> GameManager:
	var tree := Engine.get_main_loop() as SceneTree
	var gms := tree.get_nodes_in_group("GameManager")
	assert(len(gms) == 1, "invalid amount of game manager")
	return gms[0]


func player() -> Player:
	var p := get_tree().get_first_node_in_group(&"Player")
	assert(is_instance_valid(p))
	return p


func add_colors(c: int, m: int, y: int) -> void:
	cyan = min(cyan + c, MAX_COLOR_VALUE)
	magenta = min(magenta + m, MAX_COLOR_VALUE)
	yellow = min(yellow + y, MAX_COLOR_VALUE)
	added_colors.emit(cyan, magenta, yellow)

	if cyan > need_cyan or magenta > need_magenta or yellow > need_yellow:
		gameover(false, "Too much color!")


func gameover(_has_won: bool, _lost_message: String = "") -> void:
	if _has_won:
		OS.alert("You won!")
	else:
		OS.alert("You lost! " + _lost_message)
