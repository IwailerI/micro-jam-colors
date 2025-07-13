class_name LevelSelectionItemButton
extends Button

var level_id: int = -1


func _pressed() -> void:
	assert(level_id >= 0, "level id was not set for the level selection")
	Persistance.load_level(level_id)
