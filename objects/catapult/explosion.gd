extends Node2D


@export_flags_2d_physics var collision := 0
@export var warning_time: float = 0.5
@export var effect_fadeout: float = 0.3

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    animation_player.play(&"explode")


func do_explosion() -> void:
    var params := PhysicsShapeQueryParameters2D.new()
    var circle := CircleShape2D.new()
    circle.radius = 60.0
    params.shape = circle
    params.transform = global_transform
    params.collision_mask = collision
    params.collide_with_areas = true
    params.collide_with_bodies = true
    var res := get_world_2d().direct_space_state.intersect_shape(params)
    for val: Dictionary in res:
        if val.collider is Player:
            var v := global_position.direction_to(val.collider.global_position)
            val.collider.die(v * 500.0)
