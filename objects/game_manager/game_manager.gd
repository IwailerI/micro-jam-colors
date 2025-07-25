class_name GameManager
extends Node

signal added_colors(r: int, g: int, b: int)
signal game_was_over(has_won: bool, lost_message: String)

const MAX_COLOR_VALUE = 4

@export_category("Color requirement")
@export_range(0, GameManager.MAX_COLOR_VALUE) var need_red: int
@export_range(0, GameManager.MAX_COLOR_VALUE) var need_green: int
@export_range(0, GameManager.MAX_COLOR_VALUE) var need_blue: int

@onready var audio_completed: AudioStreamPlayer = $Completed
@onready var audio_pickup: AudioStreamPlayer = $Pickup
@onready var audio_bad: AudioStreamPlayer = $Bad

## Used by pause menu to check if game paused because of the menu or if game has ended
var playing: bool = true

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


func requirement_check() -> bool:
	return red == need_red && green == need_green && blue == need_blue


func add_colors(r: int, g: int, b: int) -> void:
	red += r
	green += g
	blue += b
	added_colors.emit(red, green, blue)

	if requirement_check():
		audio_completed.play()
	else:
		audio_pickup.play()
		
	if red > need_red:
		gameover(false, "Too much RED color!")
		audio_bad.play()
	elif green > need_green:
		gameover(false, "Too much GREEN color!")
		audio_bad.play()
	elif blue > need_blue:
		gameover(false, "Too much BLUE color!")
		audio_bad.play()


func gameover(has_won: bool, lost_message: String = "") -> void:
	playing = false
	get_tree().paused = true
	if has_won: Persistance.complete_last_loaded()
	game_was_over.emit(has_won, lost_message)
