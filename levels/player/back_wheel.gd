extends Polygon2D

@export var front_wheel: Node2D = null

var length: float

func _ready():
	length = (front_wheel.global_position - global_position).length()

func _physics_process(delta: float) -> void:
	var target_pos := front_wheel.global_position
	var current_pos := global_position
	global_position = target_pos + (current_pos - target_pos).normalized() * length
	rotation = position.angle_to_point(target_pos) + PI * 0.5
