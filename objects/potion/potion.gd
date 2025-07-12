extends Area2D


@export_category("Color values")
@export_range(0, 1) var red: int
@export_range(0, 1) var green: int
@export_range(0, 1) var blue: int

@onready var gm: GameManager = GameManager.get_instance()

func _ready() -> void:
	assert(red == 1 || green == 1 || blue == 1)
	var color = Color(red, green, blue, 1) # TODO: maybe change to different color Pallet
	$Polygon2D.color = color # TODO: change to sprite
	gm.player().died.connect(
		func() -> void:
			monitoring = false
	)


func _on_body_entered(_body: Node2D) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	gm.add_colors(red, green, blue)
