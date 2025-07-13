@tool
extends Node2D


@export var r: float = 16.0:
    set(v):
        r = v
        queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(-Vector2.ONE * r, Vector2.ONE * r * 2), Color.WHITE)
