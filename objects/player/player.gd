class_name Player

extends CharacterBody2D

signal died()

@export var death_accel := 300.0
@export var rotation_speed: float = PI
@export var base_speed: float = 150.0
@export var max_speed: float = 500.0
@export var throttle_acceleration: float = 50.0
@export var passive_acceleration: float = -25.0 # deceleration when not pressing throttle

@onready var radius := ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Node2D = $Polygon2D
@onready var speed: float = base_speed

var direction: float = -PI * 0.5
var alive := true
var death_time := 0 # Millisecond ticks

func _physics_process(delta: float) -> void:
	if alive:
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

	for i: int in 32:
		var col := move_and_collide(Vector2.from_angle(direction) * left)
		if col == null:
			break
		
		if (col.get_collider() as Node).is_in_group(&"Hazard"):
			alive = false
		
		var normal := col.get_normal()
		global_position = col.get_position() + radius * normal

		direction = col.get_remainder().bounce(normal).angle()
		left = col.get_remainder().length()
	

	if not alive:
		velocity = Vector2.from_angle(direction) * speed # is this right?
		death_time = Time.get_ticks_msec()
		died.emit()


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
