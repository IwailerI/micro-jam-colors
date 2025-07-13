extends Control


@onready var gm: GameManager = GameManager.get_instance()


func _ready() -> void:
	gm.game_was_over.connect(
		func(_has_won: bool, _lsot_message: String) -> void:
			set_process_input(false)
			visible = false
	)
	$VBoxContainer/Continue.pressed.connect(
		func() -> void:
			_toggle()
	)


func _toggle() -> void:
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	$VBoxContainer/Continue.grab_focus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle()
