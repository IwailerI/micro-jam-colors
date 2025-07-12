class_name Player

extends CharacterBody2D

signal died()

@export var death_accel := 300.0
@export var rotation_speed: float = PI
@export var base_speed: float = 150.0
@export var max_speed: float = 500.0
@export var throttle_acceleration: float = 50.0
@export var passive_acceleration: float = -25.0 # deceleration when not pressing throttle

@export_category("Ramping")
@export var ramping_time: float = 1.0
@export var ramping_speed: float = 500.0
@export_flags_2d_physics var ramping_collision: int = 1

@onready var radius := ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Node2D = $Polygon2D
@onready var speed: float = base_speed

var direction: float = -PI * 0.5
var alive := true
var death_time := 0 # Millisecond ticks
var ramping := false


func _physics_process(delta: float) -> void:
	if alive:
		if ramping:
			_ramping_movement(delta)
		else:
			_alive_movement(delta)
	else:
		_dead_movement(delta)
	
	
func _alive_movement(delta: float) -> void:

	# handling throttle
	var throttle_pressed := Input.is_action_pressed("throttle")
	var acceleration: float = throttle_acceleration if throttle_pressed else passive_acceleration
	speed = clamp(speed + acceleration * delta, base_speed, max_speed)

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

	sprite.rotation = direction + PI * 0.5

	var left := speed * delta

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


func _ramping_movement(delta: float) -> void:
	sprite.rotation = direction + PI * 0.5

	var left := ramping_speed * delta

	for i: int in 32:
		var col := move_and_collide(Vector2.from_angle(direction) * left)
		if col == null:
			break
		
		var normal := col.get_normal()
		global_position = col.get_position() + radius * normal

		direction = col.get_remainder().bounce(normal).angle()
		left = col.get_remainder().length()


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
	if ramping:
		return # do not case ¯\_(ツ)_/¯

	if not alive:
		return

	alive = false
	if vel == Vector2.ZERO:
		velocity = Vector2.from_angle(direction) * speed
	else:
		velocity = vel
	death_time = Time.get_ticks_msec()
	died.emit()


func do_ramp() -> void:
	if ramping:
		return
	ramping = true

	var was := collision_mask
	set_deferred("collision_mask", ramping_collision)
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).chain()
	t.tween_property(sprite, "scale", Vector2.ONE * 1.5, 0.5)
	t.tween_interval(ramping_time - 1.0)
	t.tween_property(sprite, "scale", Vector2.ONE, 0.5)

	await get_tree().create_timer(ramping_time).timeout

	ramping = false
	set_deferred("collision_mask", was)
	create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART).tween_property(sprite, "scale", Vector2.ONE, 0.5)
