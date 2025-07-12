extends CharacterBody2D


@export var speed := 400.0
var creator: Node = null


func _ready() -> void:
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
