extends Area2D


@onready var gm: GameManager = GameManager.get_instance()


func _on_body_entered(_body: Node2D) -> void:
	if gm.requirement_check():
		gm.gameover(true)
		return
