extends StaticBody2D


const CROSSBOW_BOLT := preload("res://objects/projectiles/crossbow_bolt.tscn")

## Duration in seconds before crossbow starts shooting.
@export var wakeup: float = 0.5
@export var cooldown: float = 1.5

@onready var cooldown_timer: Timer = $Cooldown
@onready var player: Player = GameManager.get_instance().player()


func _ready() -> void:
	_setup.call_deferred() # awaiting in ready is bad
	cooldown_timer.timeout.connect(_on_shoot_cooldown_timeout)


func _setup() -> void:
	if wakeup > 0:
		await get_tree().create_timer(wakeup).timeout
	cooldown_timer.start(cooldown)


func _physics_process(_delta: float) -> void:
	look_at(player.position) # TODO(wailer): mb to preemtive, but no


func _on_shoot_cooldown_timeout() -> void:
	var inst := CROSSBOW_BOLT.instantiate() as Node2D
	get_parent().add_child(inst)
	inst.global_rotation = global_rotation
	inst.global_position = global_position
	inst.creator = self
