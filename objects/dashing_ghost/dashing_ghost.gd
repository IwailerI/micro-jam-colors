extends CharacterBody2D


const GHOST = preload("res://objects/ghost/ghost.tscn")


@export var speed: float = 600
@export var rest_accel: float = 400.0

var done_funny := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play(&"idle")


func _physics_process(delta: float) -> void:
	if not GameManager.get_instance().player().alive and not done_funny:
		queue_free()
		var inst := GHOST.instantiate()
		get_parent().add_child(inst)
		inst.global_position = global_position
		done_funny = true
		return

	if done_funny:
		return

	velocity = velocity.move_toward(Vector2.ZERO, rest_accel * delta)
	var rem := velocity * delta

	for i: int in 32:
		var col := move_and_collide(rem)
		if col == null:
			break

		_on_body_entered(col.get_collider())
		
		var normal := col.get_normal()
		const RADIUS := 7.0 # don't look here
		global_position = col.get_position() + RADIUS * normal
		velocity = velocity.bounce(normal)
		rem = rem.bounce(normal)
	

func _on_body_entered(b: Node2D) -> void:
	if b is not Player:
		return
	b.die(b.global_position.direction_to(global_position) * 100.0)


func _on_dash_timer() -> void:
	var p := GameManager.get_instance().player()
	var dir := to_local(p.global_position).normalized()
	velocity = dir * speed