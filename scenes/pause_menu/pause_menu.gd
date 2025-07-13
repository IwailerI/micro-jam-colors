extends Control


@onready var gm: GameManager = GameManager.get_instance()


func _process(_delta: float) -> void:
	visible = get_tree().paused && gm.playing


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
