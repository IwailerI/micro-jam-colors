extends Control


func _ready() -> void:
	GameManager.get_instance().game_was_over.connect(
		func(_has_won: bool, _lost_message: String) -> void:
			visible = true
	)
