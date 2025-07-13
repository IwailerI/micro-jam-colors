extends PanelContainer


@export var animation_duration := 0.5
@export var color_good := Color.LIME
@export var color_bad := Color.MAROON

@onready var progress_c: ProgressBar = %ProgressC
@onready var progress_m: ProgressBar = %ProgressM
@onready var progress_y: ProgressBar = %ProgressY

@onready var target_c: Panel = %TargetC
@onready var target_m: Panel = %TargetM
@onready var target_y: Panel = %TargetY


func _ready() -> void:
    var gm := GameManager.get_instance()
    gm.added_colors.connect(func(c: int, m: int, y: int) -> void:
        set_state(-Vector3i.ONE, Vector3i(c, m, y)))

    set_state(Vector3i(gm.need_cyan, gm.need_magenta, gm.need_yellow), Vector3i.ZERO, 0)


func set_state(want: Vector3i, have: Vector3i, dur := NAN) -> void:
    var gm := GameManager.get_instance()

    if is_nan(dur):
        dur = animation_duration
    if want == -Vector3i.ONE:
        want = Vector3i(gm.need_cyan, gm.need_magenta, gm.need_yellow)
    if have == -Vector3i.ONE:
        have = Vector3i(gm.cyan, gm.magenta, gm.yellow)

    var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel()

    have = have.clamp(Vector3.ZERO, Vector3i.ONE * 4)
    t.tween_property(progress_c, "value", have.x / 4.0, dur)
    t.tween_property(progress_m, "value", have.y / 4.0, dur)
    t.tween_property(progress_y, "value", have.z / 4.0, dur)

    want = want.clamp(Vector3.ZERO, Vector3i.ONE * 4)
    t.tween_property(target_c, "anchor_top", 1.0 - want.x / 4.0, dur)
    t.tween_property(target_m, "anchor_top", 1.0 - want.y / 4.0, dur)
    t.tween_property(target_y, "anchor_top", 1.0 - want.z / 4.0, dur)

    t.tween_property(target_c, "self_modulate", _get_target_col(have.x, want.x), dur)
    t.tween_property(target_m, "self_modulate", _get_target_col(have.y, want.y), dur)
    t.tween_property(target_y, "self_modulate", _get_target_col(have.z, want.z), dur)


func _get_target_col(have: int, want: int) -> Color:
    if have > want:
        return color_bad
    elif have < want:
        return Color.WHITE
    else:
        return color_good