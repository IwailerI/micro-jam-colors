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

@onready var nodes := {
	r = {
		unlit = [$RGB/R/Unlit1, $RGB/R/Unlit2, $RGB/R/Unlit3, $RGB/R/Unlit4],
		lit = [$RGB/R/Lit1, $RGB/R/Lit2, $RGB/R/Lit3, $RGB/R/Lit4],
	},
	g = {
		unlit = [$RGB/G/Unlit1, $RGB/G/Unlit2, $RGB/G/Unlit3, $RGB/G/Unlit4],
		lit = [$RGB/G/Lit1, $RGB/G/Lit2, $RGB/G/Lit3, $RGB/G/Lit4],
	},
	b = {
		unlit = [$RGB/B/Unlit2, $RGB/B/Unlit3, $RGB/B/Unlit4, $RGB/B/Unlit1],
		lit = [$RGB/B/Lit2, $RGB/B/Lit3, $RGB/B/Lit4, $RGB/B/Lit1],
	},
}

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

	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE).set_parallel()

	have = have.clamp(Vector3.ZERO, Vector3i.ONE * 4)
	want = want.clamp(Vector3.ZERO, Vector3i.ONE * 4)

	_do_color(t, nodes.r, have.x, want.x, dur)
	_do_color(t, nodes.g, have.y, want.y, dur)
	_do_color(t, nodes.b, have.z, want.z, dur)

	var col_have := Color(have.x / 4.0, have.y / 4.0, have.z / 4.0)
	var col_want := Color(want.x / 4.0, want.y / 4.0, want.z / 4.0)
	t.tween_property(potion, "modulate", col_have, dur)
	t.tween_property(paper, "modulate", col_want, dur)


func _do_color(t: Tween, data: Dictionary, have: int, want: int, dur: float) -> void:
	for i: int in 4:
		t.tween_property(data.unlit[i], "modulate:a", float(want > i), dur)
		t.tween_property(data.lit[i], "modulate:a", float(have > i), dur)


func _get_target_col(have: int, want: int) -> Color:
	if have > want:
		return color_bad
	elif have < want:
		return Color.WHITE
	else:
		return color_good
