class_name Player

extends CharacterBody2D

signal died()

const RAMPING_TIME: float = 0.6

@export var death_accel := 300.0
@export var rotation_speed: float = PI
@export var base_speed: float = 150.0
@export var max_speed: float = 500.0
@export var throttle_acceleration: float = 50.0
@export var passive_acceleration: float = -25.0 # deceleration when not pressing throttle

@export var menu := false

@export_category("Ramping")
@export var ramping_speed: float = 500.0
@export_flags_2d_physics var ramping_collision: int = 1

@onready var radius := ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Node2D = $Sprite2D
@onready var speed: float = base_speed
@onready var death_animation_timer: Timer = $DeathTimer
@onready var normal_collision_mask: int
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var direction: float = -PI * 0.5
var alive := true
var ramping := false
var ramping_done := false # set after ramping interval passes
var dead_rotation: float = 0.0


func _ready() -> void:
	normal_collision_mask = collision_mask
	if menu:
		direction = PI * 0.25
		global_rotation = direction


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
	var throttle_pressed := not menu and Input.is_action_pressed("throttle")
	var acceleration: float = throttle_acceleration if throttle_pressed else passive_acceleration
	speed = clamp(speed + acceleration * delta, base_speed, max_speed)

	# handling direction
	var inp := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	if menu:
		inp = Vector2.ZERO

	var wanted_angle := 0.0
	if inp.is_zero_approx():
		wanted_angle = direction
	else:
		wanted_angle = inp.angle()

	if is_equal_approx(absf(angle_difference(direction, wanted_angle)), PI):
		wanted_angle += 0.001 # always clockwise on 180 turn

	direction = rotate_toward(direction, wanted_angle, rotation_speed * delta)

	sprite.global_rotation = direction + PI * 0.5

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
	sprite.global_rotation = direction + PI * 0.5

	var left := ramping_speed * delta

	for i: int in 32:
		var col := move_and_collide(Vector2.from_angle(direction) * left)
		if col == null:
			break

		var normal := col.get_normal()
		global_position = col.get_position() + radius * normal

		direction = col.get_remainder().bounce(normal).angle()
		left = col.get_remainder().length()

	if ramping_done: # try landing
		var params := PhysicsShapeQueryParameters2D.new()
		params.collide_with_areas = false
		params.collide_with_bodies = true
		params.collision_mask = normal_collision_mask
		params.shape = collision_shape_2d.shape
		params.transform = collision_shape_2d.global_transform

		if not get_world_2d().direct_space_state.intersect_shape(params).is_empty():
			# well, let's just hope the next frame this will get better
			return

		ramping = false
		set_deferred("collision_mask", normal_collision_mask)


func _dead_movement(delta: float) -> void:
	dead_rotation += delta * PI

	velocity = velocity.move_toward(Vector2.ZERO, death_accel * delta)
	var rem := velocity * delta
	for i: int in 32:
		var col := move_and_collide(rem)
		if col == null:
			break

		var normal := col.get_normal()
		global_position = col.get_position() + radius * normal
		rem = col.get_remainder().bounce(normal)
		velocity = velocity.bounce(normal)

	sprite.global_rotation = dead_rotation


func die(vel := Vector2.ZERO) -> void:
	if ramping:
		return # do not care ¯\_(ツ)_/¯

	if not alive:
		return

	audio.play()
	alive = false
	if vel == Vector2.ZERO:
		velocity = Vector2.from_angle(direction) * speed
	else:
		velocity = vel
	death_animation_timer.timeout.connect(_finish_dying)
	death_animation_timer.start()
	dead_rotation = rotation
	died.emit()


func _finish_dying():
	GameManager.get_instance().gameover(false, "died")


func do_ramp() -> void:
	if ramping:
		return
	ramping = true
	ramping_done = false

	set_deferred("collision_mask", ramping_collision)
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).chain()
	t.tween_property(sprite, "scale", Vector2.ONE * 1.5, 0.3)
	t.tween_property(sprite, "scale", Vector2.ONE, 0.3)
	t.tween_callback(set.bind("ramping_done", true))
