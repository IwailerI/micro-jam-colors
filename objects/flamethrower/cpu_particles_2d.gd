extends CPUParticles2D


func _ready() -> void:
	gravity = Vector2.from_angle(get_parent().global_rotation).normalized() * 100
