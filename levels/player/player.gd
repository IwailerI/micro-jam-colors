extends CharacterBody2D

enum CollisionAlgo {
    BOUNCE,
    SLIDE,
}

@export var collision_algo := CollisionAlgo.BOUNCE
@export var rotation_speed := PI
@export var ground_speed := 200.0

@onready var radius := ($CollisionShape2D.shape as CircleShape2D).radius

var direction: float = -PI * 0.5


func _physics_process(delta: float) -> void:
    var inp := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
    var wanted_angle := 0.0
    if inp.is_zero_approx():
        wanted_angle = direction
    else:
        wanted_angle = inp.angle()

    direction = rotate_toward(direction, wanted_angle, rotation_speed * delta)
    # prints(direction, wanted_angle)

    $Polygon2D.rotation = direction + PI * 0.5

    var left := ground_speed * delta

    for i: int in 32:
        var col := move_and_collide(Vector2.from_angle(direction) * left)
        if col == null:
            break
        
        var normal := col.get_normal()
        global_position = col.get_position() + radius * normal

        match collision_algo:
            CollisionAlgo.BOUNCE:
                direction = col.get_remainder().bounce(normal).angle()
            CollisionAlgo.SLIDE:
                var wall_angle := normal.angle() + PI * 0.5
                var deflect := randf_range(0, PI * 0.2)

                if absf(angle_difference(wall_angle, direction)) < absf(angle_difference(-wall_angle, direction)):
                    direction = wall_angle + deflect
                elif absf(angle_difference(wall_angle, direction)) > absf(angle_difference(-wall_angle, direction)):
                    direction = -wall_angle - deflect
                else:
                    direction = wall_angle + deflect if randi() % 2 == 0 else -wall_angle - deflect

        
        left = col.get_remainder().length()
