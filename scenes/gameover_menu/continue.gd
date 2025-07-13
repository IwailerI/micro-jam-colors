extends Button

var next_id: int


func _ready() -> void:
	next_id = Persistance.last_loaded_id + 1
	GameManager.get_instance().game_was_over.connect(
		func(has_won: bool, lost_message: String) -> void:
			visible = next_id < Persistance.LEVEL_AMOUNT && has_won
	)


func _pressed() -> void:
	Persistance.load_level(next_id)
