@tool
extends Area2D


const PALETTE := preload("res://objects/palette/default.tres")

@export_group("Color values")
@export var cyan: bool = false:
	set(v):
		cyan = v
		_update_colors()
@export var magenta: bool = false:
	set(v):
		magenta = v
		_update_colors()
@export var yellow: bool = false:
	set(v):
		yellow = v
		_update_colors()

@onready var gm: GameManager = GameManager.get_instance()
@onready var glow: Node2D = $Glow


func _ready() -> void:
	_update_colors()
	if not Engine.is_editor_hint():
		assert(cyan or magenta or yellow, "colorless potion")
		gm.player().died.connect(
			func() -> void:
				monitoring = false
		)


func _on_body_entered(_body: Node2D) -> void:
	if Engine.is_editor_hint():
		return
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
	gm.add_colors(int(cyan), int(magenta), int(yellow))


func _update_colors() -> void:
	var color := PALETTE.lookup(cyan, magenta, yellow)
	$Polygon.color = color
	$Glow.modulate = color
