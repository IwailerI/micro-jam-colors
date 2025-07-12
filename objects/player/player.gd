extends CharacterBody2D

enum CollisionAlgo {
	BOUNCE,
	SLIDE,
}

@export var collision_algo := CollisionAlgo.BOUNCE
@export var rotation_speed: float = PI
@export var base_speed: float = 150.0
@export var max_speed: float = 500.0
@export var throttle_acceleration: float = 50.0
@export var passive_acceleration: float = -25.0 # deceleration when not pressing throttle

@onready var radius := ($CollisionShape2D.shape as CircleShape2D).radius

var direction: float = -PI * 0.5
@onready var speed: float = base_speed

func _physics_process(delta: float) -> void:
	# handling throttle
	var throttle_pressed := Input.is_action_pressed("throttle")
	var acceleration: float = throttle_acceleration if throttle_pressed else passive_acceleration
	speed = clamp(speed + acceleration * delta, base_speed, max_speed)
	print(speed)

	# handling direction
	var inp := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")

	var wanted_angle := 0.0
	if inp.is_zero_approx():
		wanted_angle = direction
	else:
		wanted_angle = inp.angle()

	if is_equal_approx(absf(angle_difference(direction, wanted_angle)), PI):
		wanted_angle += 0.001 # always clockwise on 180 turn

	direction = rotate_toward(direction, wanted_angle, rotation_speed * delta)

	var left := speed * delta
	$Polygon2D.rotation = direction + PI * 0.5


	for i: int in 32:
		var col := move_and_collide(Vector2.from_angle(direction) * left)
		if col == null:
			break
		
		var normal := col.get_normal()
		global_position = col.get_position() + radius * normal

		match collision_algo:
			CollisionAlgo.BOUNCE:
				direction = col.get_remainder().bounce(normal).angle()
			CollisionAlgo.SLIDE:
				var wall_angle := normal.angle() + PI * 0.5
				var deflect := randf_range(0, PI * 0.2)

				if absf(angle_difference(wall_angle, direction)) < absf(angle_difference(-wall_angle, direction)):
					direction = wall_angle + deflect
				elif absf(angle_difference(wall_angle, direction)) > absf(angle_difference(-wall_angle, direction)):
					direction = - wall_angle - deflect
				else:
					direction = wall_angle + deflect if randi() % 2 == 0 else -wall_angle - deflect

		
		left = col.get_remainder().length()
