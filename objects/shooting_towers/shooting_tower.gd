extends StaticBody2D



@export var projectile_prefab: PackedScene
@export var projectile_speed: float = 0.0
## Duration in seconds before crossbow starts shooting.
@export var wakeup: float = 0.5
@export var cooldown: float = 1.5
@export var rotating_to_player: bool = false

@onready var cooldown_timer: Timer = $Cooldown
@onready var player: Player = GameManager.get_instance().player()
@onready var marker: Marker2D = $Marker2D


func _ready() -> void:
	_setup.call_deferred() # awaiting in ready is bad
	cooldown_timer.timeout.connect(_on_shoot_cooldown_timeout)


func _setup() -> void:
	if wakeup > 0:
		await get_tree().create_timer(wakeup).timeout
	cooldown_timer.start(cooldown)


func _physics_process(_delta: float) -> void:
	if rotating_to_player:
		look_at(player.position) # TODO(wailer): mb to preemtive, but no


func _on_shoot_cooldown_timeout() -> void:
	var inst := projectile_prefab.instantiate() as Projectile
	inst.speed = projectile_speed
	get_parent().add_child(inst)
	inst.global_rotation = global_rotation
	inst.global_position = marker.global_position
	inst.creator = self
