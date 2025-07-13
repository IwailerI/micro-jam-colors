@tool
extends Area2D


const PALETTE := preload("res://objects/palette/default.tres")

@export_group("Color values")
@export var red: bool = false:
	set(v):
		red = v
		_update_colors()
@export var green: bool = false:
	set(v):
		green = v
		_update_colors()
@export var blue: bool = false:
	set(v):
		blue = v
		_update_colors()

@onready var gm: GameManager = GameManager.get_instance()
@onready var glow: Node2D = $Glow


func _ready() -> void:
	_update_colors()
	if not Engine.is_editor_hint():
		assert(red or green or blue, "colorless potion")
		gm.player().died.connect(
			func() -> void:
				monitoring = false
		)


func _on_body_entered(_body: Node2D) -> void:
	if Engine.is_editor_hint():
		return
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
	gm.add_colors(int(red), int(green), int(blue))


func _update_colors() -> void:
	var color := PALETTE.lookup(red, green, blue)
	$Polygon.color = color
	$Glow.modulate = color
