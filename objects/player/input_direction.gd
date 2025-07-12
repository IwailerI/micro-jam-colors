extends Node2D


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var inp := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	draw_circle(Vector2.ZERO, 20.0, Color.RED)
	draw_line(Vector2.ZERO, inp * 100.0, Color.RED, 5)
