extends Area2D

@export_category("Color values")
@export_range(0, 1) var red: int
@export_range(0, 1) var green: int
@export_range(0, 1) var blue: int

func _ready() -> void:
	var color = Color(red, green, blue, 1) # TODO: maybe change to different color Pallet
	$Polygon2D.color = color


func _on_body_entered(_body: Node2D) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	GameManager.GetInstance().AddColors(red, green, blue)
