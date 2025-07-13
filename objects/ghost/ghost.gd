extends Area2D


@export var speed: float = 150
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
    body_entered.connect(_on_body_entered)
    animation_player.play(&"idle")


func _physics_process(delta: float) -> void:
    var p := GameManager.get_instance().player()

    var dir := to_local(p.global_position)
    if not p.alive:
        dir = Vector2.UP
        modulate.a = move_toward(modulate.a, 0, delta * 0.7)
    
    position += dir.normalized() * delta * speed
    sprite_2d.look_at(to_global(dir))
    

func _on_body_entered(b: Node2D) -> void:
    if b is not Player:
        return
    b.die(b.global_position.direction_to(global_position) * 100.0)