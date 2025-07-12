extends Node2D

@export var hand: Node2D = null
@export var min_angle: float = PI * (-1.1)
@export var max_angle: float = PI * 0.1

var player: Player
var max_speed: float


func _ready() -> void:
	player = GameManager.get_instance().player()
	max_speed = player.max_speed


func _process(_delta: float) -> void:
	var speed: float = player.speed if player.alive else 0.0

	# hand.rotation = (1 - speed / max_speed) * PI * (-1)
	hand.rotation = lerp(min_angle, max_angle, speed / max_speed)
	
