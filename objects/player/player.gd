class_name Player
extends CharacterBody2D


signal died()

@export var rotation_speed := PI
@export var ground_speed := 200.0
@export var death_accel := 300.0

@onready var radius := ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Node2D = $Polygon2D

var direction: float = -PI * 0.5
var alive := true
var death_time := 0 # Millisecond ticks


func _physics_process(delta: float) -> void:
	if alive:
		_alive_movement(delta)
	else:
		_dead_movement(delta)
	
	
func _alive_movement(delta: float) -> void:
	var inp := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	var wanted_angle := 0.0
	if inp.is_zero_approx():
		wanted_angle = direction
	else:
		wanted_angle = inp.angle()

	if is_equal_approx(absf(angle_difference(direction, wanted_angle)), PI):
		wanted_angle += 0.001 # always clockwise on 180 turn

	direction = rotate_toward(direction, wanted_angle, rotation_speed * delta)

	sprite.rotation = direction + PI * 0.5

	var left := ground_speed * delta

	var was_leathal := false

	for i: int in 32:
		var col := move_and_collide(Vector2.from_angle(direction) * left)
		if col == null:
			break
		
		if (col.get_collider() as Node).is_in_group(&"Hazard"):
			was_leathal = true
		
		var normal := col.get_normal()
		global_position = col.get_position() + radius * normal

		
		direction = col.get_remainder().bounce(normal).angle()
		left = col.get_remainder().length()

	if was_leathal:
		die()
		

func _dead_movement(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, death_accel * delta)
	for i: int in 32:
		var col := move_and_collide(velocity * delta)
		if col == null:
			break
		
		var normal := col.get_normal()
		global_position = col.get_position() + radius * normal
		velocity = col.get_remainder().bounce(normal)

	sprite.rotation = velocity.angle() + PI * 0.5 + float(Time.get_ticks_msec() - death_time) * 0.001 * PI


func die(vel := Vector2.ZERO) -> void:
	if not alive:
		return

	alive = false
	if vel == Vector2.ZERO:
		velocity = Vector2.from_angle(direction) * ground_speed
	else:
		velocity = vel
	death_time = Time.get_ticks_msec()
	died.emit()