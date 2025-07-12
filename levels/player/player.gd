extends CharacterBody2D

@export var rotation_speed := PI
@export var ground_speed := 200.0

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

    var col := move_and_collide(Vector2.from_angle(direction) * ground_speed * delta)
    if col != null:
        print("collision")
