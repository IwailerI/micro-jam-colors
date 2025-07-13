extends StaticBody2D


const CATAPULT_EXPLOSION := preload("res://objects/catapult/explosion.tscn")

## Duration in seconds before catapults starts throwing.
@export var wakeup: float = 3
@export var cooldown: float = 3
@export var preempt_player: bool = true

@onready var cooldown_timer: Timer = $Cooldown
@onready var gun: AnimatedSprite2D = $Gun
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var target := Vector2.ZERO
var has_target := false


func _ready() -> void:
	_setup.call_deferred() # awaiting in read is bad
	cooldown_timer.timeout.connect(_on_shoot_cooldown_timeout)
	gun.animation_finished.connect(func() -> void:
		gun.play("default"))


func _setup() -> void:
	if wakeup > 0:
		await get_tree().create_timer(wakeup).timeout
	_on_shoot_cooldown_timeout()
	cooldown_timer.start(cooldown)


func _on_shoot_cooldown_timeout() -> void:
	var p := GameManager.get_instance().player()
	if not p.alive:
		return
	
	const WARN_TIME := 0.6

	var pos: Vector2
	if preempt_player:
		pos = p.global_position + Vector2.from_angle(p.direction) * p.base_speed * WARN_TIME
	else:
		pos = p.global_position

	has_target = true
	target = pos

	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()

	get_tree().create_timer(WARN_TIME - 0.2).timeout.connect(func() -> void:
		gun.play("shoot")
		await get_tree().create_timer(0.2).timeout
		has_target = false)

	var inst := CATAPULT_EXPLOSION.instantiate() as Node2D
	inst.source = global_position
	inst.global_rotation = global_rotation
	inst.global_position = pos
	get_parent().add_child(inst)


func _physics_process(_delta: float) -> void:
	if has_target:
		gun.look_at(target)
	else:
		var p := GameManager.get_instance().player()
		gun.look_at(p.global_position)
