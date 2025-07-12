class_name GameManager
extends Node

signal added_colors(r: int, g: int, b: int)

const MAX_COLOR_VALUE = 4

var red: int = 0
var green: int = 0
var blue: int = 0


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


func add_colors(r: int, g: int, b: int) -> void:
	red = min(red + r, MAX_COLOR_VALUE)
	green = min(green + g, MAX_COLOR_VALUE)
	blue = min(blue + b, MAX_COLOR_VALUE)
	added_colors.emit(red, green, blue)


func gameover(_has_won: bool, _lost_message: String = "") -> void:
	if _has_won:
		OS.alert("You won!")
	else:
		OS.alert("You lost! " + _lost_message)
