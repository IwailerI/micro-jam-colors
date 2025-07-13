extends PanelContainer


@export var animation_duration := 0.5
@export var color_good := Color.LIME
@export var color_bad := Color.MAROON

@onready var progress_r: ProgressBar = %ProgressR
@onready var progress_g: ProgressBar = %ProgressG
@onready var progress_b: ProgressBar = %ProgressB

@onready var target_r: Panel = %TargetR
@onready var target_g: Panel = %TargetG
@onready var target_b: Panel = %TargetB

@onready var potion: TextureRect = %Potion
@onready var paper: TextureRect = %Paper

func _ready() -> void:
	var gm := GameManager.get_instance()
	gm.added_colors.connect(func(c: int, m: int, y: int) -> void:
		set_state(-Vector3i.ONE, Vector3i(c, m, y)))

	set_state(Vector3i(gm.need_red, gm.need_green, gm.need_blue), Vector3i.ZERO, 0)


func set_state(want: Vector3i, have: Vector3i, dur := NAN) -> void:
	var gm := GameManager.get_instance()

	if is_nan(dur):
		dur = animation_duration
	if want == -Vector3i.ONE:
		want = Vector3i(gm.need_red, gm.need_green, gm.need_blue)
	if have == -Vector3i.ONE:
		have = Vector3i(gm.red, gm.green, gm.blue)

	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel()

	have = have.clamp(Vector3.ZERO, Vector3i.ONE * 4)
	t.tween_property(progress_r, "value", have.x / 4.0, dur)
	t.tween_property(progress_g, "value", have.y / 4.0, dur)
	t.tween_property(progress_b, "value", have.z / 4.0, dur)

	want = want.clamp(Vector3.ZERO, Vector3i.ONE * 4)
	t.tween_property(target_r, "anchor_top", 1.0 - want.x / 4.0, dur)
	t.tween_property(target_g, "anchor_top", 1.0 - want.y / 4.0, dur)
	t.tween_property(target_b, "anchor_top", 1.0 - want.z / 4.0, dur)

	t.tween_property(target_r, "self_modulate", _get_target_col(have.x, want.x), dur)
	t.tween_property(target_g, "self_modulate", _get_target_col(have.y, want.y), dur)
	t.tween_property(target_b, "self_modulate", _get_target_col(have.z, want.z), dur)

	var col_have := Color(have.x / 4.0, have.y / 4.0, have.z / 4.0)
	var col_want := Color(want.x / 4.0, want.y / 4.0, want.z / 4.0)
	t.tween_property(potion, "modulate", col_have, dur)
	t.tween_property(paper, "modulate", col_want, dur)


func _get_target_col(have: int, want: int) -> Color:
	if have > want:
		return color_bad
	elif have < want:
		return Color.WHITE
	else:
		return color_good
