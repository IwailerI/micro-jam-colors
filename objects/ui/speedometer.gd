extends Node2D

@export var hand: Node2D = null
@export var player: Player = null
@export var min_angle: float = PI * (-1.1)
@export var max_angle: float = PI * 0.1

# TODO: get from player
@onready var max_speed: float = player.max_speed


func _process(_delta: float) -> void:
	# TODO: get from player
	var speed: float = player.speed

	# hand.rotation = (1 - speed / max_speed) * PI * (-1)
	hand.rotation = lerp(min_angle, max_angle, speed / max_speed)
	
