extends Area2D


const PALETTE := preload("res://objects/palette/default.tres")

@export_group("Color values")
@export var cyan: bool = false
@export var magenta: bool = false
@export var yellow: bool = false

@onready var gm: GameManager = GameManager.get_instance()
@onready var glow: Node2D = $Glow


func _ready() -> void:
	assert(cyan or magenta or yellow, "colorless potion")
	var color := PALETTE.lookup(cyan, magenta, yellow)
	$Polygon.color = color
	$Glow.modulate = color
	gm.player().died.connect(
		func() -> void:
			monitoring = false
	)


func _on_body_entered(_body: Node2D) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
	gm.add_colors(int(cyan), int(magenta), int(yellow))
