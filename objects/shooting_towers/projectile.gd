class_name Projectile
extends CharacterBody2D


var speed: float = 0.0
var creator: Node = null


func _ready() -> void:
	assert(speed > 0.0)
	($Visibility as VisibleOnScreenNotifier2D).screen_exited.connect(queue_free)


func _physics_process(delta: float) -> void:
	velocity = Vector2.from_angle(global_rotation) * speed * delta
	var rem := velocity
	for i: int in 32:
		var col := move_and_collide(rem)
		if col == null:
			break
		if col.get_collider() is Player:
			col.get_collider().die()
		if col.get_collider() != creator:
			queue_free()
		rem = col.get_remainder()
