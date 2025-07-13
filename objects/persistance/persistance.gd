extends Node

const SAVE_FILE: String = "user://BAK_completed"

const SOUND_FILE: String = "user://sounds.json"

## Path to load a level.
## Usage: LEVEL_PATH % level_id
const LEVEL_PATH: String = "res://levels/level_%d.tscn"

## id: name
const LEVEL_NAME: Dictionary = {
	 0: "Tutorial",
	 1: "City center",
	 2: "Home invasion",
	 3: "Open crossroad",
	 4: " II double lanes",
	 5: "Haunted disaster",
	 6: "Overbrew",
	 7: "Ghost Dash v2.1",
	 8: "Hot day Mai-ai-mi",
	 9: "Through the Fire and Flames",
	10: "Ghost Dash v2.2",
	11: "TOC-1 - theory of colors",
	12: "Bad Pot Cream",
	13: "Possible game",
	14: "Big Mother Gun",
	15: "Two Mother Gun",
	16: "III triple lanes",
	17: "TOC-2 - theory of colors",
	18: "Attack on Ghosts",
	19: "A-VV-ARIA",
	20: "FINALE",
}

## How many levels does the game has.
## Starts with 1 till amount-1 (0 level is tutorial).
var LEVEL_AMOUNT: int = LEVEL_NAME.size() - 1

var sounds: Array = [0.5, 0.5, 0.5]
var completed_amount: int = 0
var last_loaded_id: int = 0


func _ready() -> void:
	if OS.is_debug_build():
		completed_amount = LEVEL_AMOUNT - 2
		_serialize()
	_deserialize()


func _serialize() -> void:
	var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	assert(file != null, str(FileAccess.get_open_error()))
	file.store_8(completed_amount)
	file.close()


func _deserialize() -> void:
	var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		completed_amount = 0
		_serialize()
		return
	completed_amount = file.get_8()
	file.close()


func get_volume(bus_id) -> float:
	var file := FileAccess.open(SOUND_FILE, FileAccess.READ)
	if file == null:
		save_volume()
		return sounds[bus_id]
	var data := file.get_as_text()
	file.close()
	sounds = JSON.parse_string(data) as Array
	print(sounds)
	return sounds[bus_id]


func save_volume() -> void:
	var data := JSON.stringify(sounds)
	var file := FileAccess.open(SOUND_FILE, FileAccess.WRITE)
	file.store_string(data)
	file.close()


func set_volume(bus_id, volume) -> void:
	sounds[bus_id] = volume
	save_volume()


## Returns the furthest available level id.
func get_furthest_id() -> int:
	return clamp(completed_amount + 1, 1, LEVEL_AMOUNT)


func load_level(id: int) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(LEVEL_PATH % id)
	last_loaded_id = id
	if !GlobalMusic.playing: GlobalMusic.play()


## Saves that last loaded level was completed.
func complete_last_loaded() -> void:
	if completed_amount < last_loaded_id:
		completed_amount = last_loaded_id
		_serialize()


## Resets completed level amount and serialize it to the save file.
func delete_progress() -> void:
	completed_amount = 0
	_serialize()
