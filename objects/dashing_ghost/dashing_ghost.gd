extends Area2D


var velocity := Vector2.ZERO
@export var speed: float = 600
@export var rest_accel: float = 400.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    body_entered.connect(_on_body_entered)
    animation_player.play(&"idle")


func _physics_process(delta: float) -> void:
    velocity = velocity.move_toward(Vector2.ZERO, rest_accel * delta)
    position += velocity * delta
    

func _on_body_entered(b: Node2D) -> void:
    if b is not Player:
        return
    b.die(b.global_position.direction_to(global_position) * 100.0)


func _on_dash_timer() -> void:
    var p := GameManager.get_instance().player()
    var dir := to_local(p.global_position).normalized()
    velocity = dir * speed