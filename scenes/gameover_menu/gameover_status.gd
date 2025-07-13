extends Label


func _ready() -> void:
	GameManager.get_instance().game_was_over.connect(
		func(has_won: bool, lost_message: String) -> void:
			text = "LEVEL COMPLETED" if has_won else "YOU LOST"
	)
