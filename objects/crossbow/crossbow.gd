extends StaticBody2D


const CROSSBOW_BOLT := preload("res://objects/crossbow/crossbow_bolt.tscn")

## Duration in seconds before crossbow starts shooting.
@export var wakeup: float = 3
@export var cooldown: float = 3

@onready var cooldown_timer: Timer = $Cooldown


func _ready() -> void:
	_setup.call_deferred() # awaiting in read is bad
	cooldown_timer.timeout.connect(_on_shoot_cooldown_timeout)


func _setup() -> void:
	if wakeup > 0:
		await get_tree().create_timer(wakeup).timeout
	cooldown_timer.start(cooldown)


func _on_shoot_cooldown_timeout() -> void:
	var inst := CROSSBOW_BOLT.instantiate() as Node2D
	get_parent().add_child(inst)
	inst.global_rotation = global_rotation
	inst.global_position = global_position
	inst.creator = self