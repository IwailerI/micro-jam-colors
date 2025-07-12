class_name GameManager
extends Node

const MAX_COLOR_VALUE = 4

var red: int = 0
var green: int = 0
var blue: int = 0


static func GetInstance() -> GameManager:
	var tree := Engine.get_main_loop() as SceneTree
	var gms := tree.get_nodes_in_group("GameManager")
	assert(len(gms) == 1, "Tried to get instance of the game manager while there is invalid amount of them.")
	return gms[0]


func AddColors(r: int, g: int, b: int):
	red = min(red + r, MAX_COLOR_VALUE)
	green = min(green + r, MAX_COLOR_VALUE)
	blue = min(blue + r, MAX_COLOR_VALUE)
