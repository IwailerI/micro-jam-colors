extends Label


func _ready() -> void:
	GameManager.get_instance().game_was_over.connect(
		func(_has_won: bool, lost_message: String) -> void:
			text = lost_message
	)
