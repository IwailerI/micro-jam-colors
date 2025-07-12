class_name GameManager
extends Node

signal added_colors(r: int, g: int, b: int)

const MAX_COLOR_VALUE = 4

var red: int = 0
var green: int = 0
var blue: int = 0


static func get_instance() -> GameManager:
	var tree := Engine.get_main_loop() as SceneTree
	var gms := tree.get_nodes_in_group("GameManager")
	assert(len(gms) == 1, "Tried to get instance of the game manager while there is invalid amount of them.")
	return gms[0]


func add_colors(r: int, g: int, b: int) -> void:
	red = min(red + r, MAX_COLOR_VALUE)
	green = min(green + g, MAX_COLOR_VALUE)
	blue = min(blue + b, MAX_COLOR_VALUE)
	added_colors.emit(red, green, blue)


func gameover(has_won: bool, lost_message: String = "") -> void:
	print("gameover was called")
