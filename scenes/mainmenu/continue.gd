extends Button

const BUTTONTEXT: String = "Continue - %d"

@onready var furthest_id: int = Persistance.get_furthest_id()


func _ready() -> void:
	text = BUTTONTEXT % (furthest_id)
	grab_focus()


func _pressed() -> void:
	Persistance.load_level(furthest_id)
