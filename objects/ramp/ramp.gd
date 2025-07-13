extends StaticBody2D


@onready var trigger: Area2D = $Trigger
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	trigger.body_entered.connect(_on_body_entered)


func _on_body_entered(b: Node2D) -> void:
	var p := b as Player
	if p == null:
		return
	
	audio.play()
	p.do_ramp()
