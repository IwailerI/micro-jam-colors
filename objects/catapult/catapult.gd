extends StaticBody2D


const CATAPULT_EXPLOSION := preload("res://objects/catapult/explosion.tscn")

## Duration in seconds before catapults starts throwing.
@export var wakeup: float = 3
@export var cooldown: float = 3
@export var preempt_player: bool = true

@onready var cooldown_timer: Timer = $Cooldown


func _ready() -> void:
	_setup.call_deferred() # awaiting in read is bad
	cooldown_timer.timeout.connect(_on_shoot_cooldown_timeout)


func _setup() -> void:
	if wakeup > 0:
		await get_tree().create_timer(wakeup).timeout
	cooldown_timer.start(cooldown)


func _on_shoot_cooldown_timeout() -> void:
	var p := GameManager.GetInstance().Player()
	if not p.alive:
		return

	var pos: Vector2
	if preempt_player:
		const WARN_TIME := 0.5
		pos = p.global_position + Vector2.from_angle(p.direction) * p.ground_speed * WARN_TIME
	else:
		pos = p.global_position

	var inst := CATAPULT_EXPLOSION.instantiate() as Node2D
	get_parent().add_child(inst)
	inst.global_rotation = global_rotation
	inst.global_position = pos


func _physics_process(_delta: float) -> void:
	var p := GameManager.GetInstance().Player()
	global_rotation = global_position.direction_to(p.global_position).angle()
