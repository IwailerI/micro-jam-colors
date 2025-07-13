extends Button

var next_id: int


func _ready() -> void:
	next_id = Persistance.last_loaded_id + 1
	GameManager.get_instance().game_was_over.connect(
		func(has_won: bool, _lost_message: String) -> void:
			visible = next_id <= Persistance.LEVEL_AMOUNT && has_won
			grab_focus()
	)


func _pressed() -> void:
	Persistance.load_level(next_id)
