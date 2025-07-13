extends Button


func _ready() -> void:
	var next_id := Persistance.last_loaded_id + 1
	GameManager.get_instance().game_was_over.connect(
		func(has_won: bool, lost_message: String) -> void:
			if not (next_id < Persistance.LEVEL_AMOUNT && has_won): grab_focus()
	)


func _pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
