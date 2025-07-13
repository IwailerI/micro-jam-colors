extends StaticBody2D


@export var wakeup: float = 0.5
@export_range(1.0, 60.0) var shooting_time: float
@export_range(1.0, 60.0) var cooldown_time: float
@export_range(0.0, 1.0) var preprocess_time: float

@onready var timer: Timer = $Timer
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var damaging_area: Area2D = $DamageArea
@onready var sprite: AnimatedSprite2D = $Sprite

var shooting: bool = false


func _ready() -> void:
	if wakeup > 0:
		await get_tree().create_timer(wakeup).timeout
	timer.timeout.connect(_toggle)
	particles.preprocess = preprocess_time
	_toggle()


func _toggle() -> void:
	shooting = not shooting

	if shooting:
		sprite.play("fire")
		sprite.speed_scale = 1.0 / shooting_time
	else:
		sprite.play_backwards("fire")
		sprite.speed_scale = 1.0 / cooldown_time

	timer.start(shooting_time if shooting else cooldown_time)
	particles.emitting = shooting
	damaging_area.monitoring = shooting
