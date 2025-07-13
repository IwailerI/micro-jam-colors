@tool
extends Node2D

const POTION := preload("res://objects/potion/potion.tscn")
const PALETTE := preload("res://objects/palette/default.tres")

@export_group("Color values")
@export var red: bool:
	set(v):
		red = v
		_update_colors()
@export var green: bool:
	set(v):
		green = v
		_update_colors()
@export var blue: bool:
	set(v):
		blue = v
		_update_colors()

@export_group("Brewing values")
@export_range(1, 60) var brewing_time: int

@export var spawn_limit: int = 0

@onready var respawn_progressbar: TextureProgressBar = $RespawnProgressBar

var respawn_timer: Timer
var potions_spawned := 0


func _ready() -> void:
	_update_colors()

	if not Engine.is_editor_hint():
		assert(red or green or blue, "colorless potion spawner")

		respawn_timer = $RespawnTimer
		respawn_timer.timeout.connect(_finish_brewing)

		_start_brewing()


func _start_brewing() -> void:
	if not respawn_timer.is_inside_tree():
		await respawn_timer.tree_entered
	respawn_timer.start(brewing_time)
	respawn_progressbar.visible = true


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	respawn_progressbar.value = 1.0 - respawn_timer.time_left / brewing_time


func _finish_brewing() -> void:
	potions_spawned += 1
	respawn_progressbar.visible = false
	var potion_node := POTION.instantiate()
	potion_node.red = red
	potion_node.green = green
	potion_node.blue = blue

	if potions_spawned == spawn_limit:
		$Polygon2D.hide()

	if spawn_limit > 0 and potions_spawned < spawn_limit:
		potion_node.tree_exited.connect(_start_brewing)

	add_child(potion_node)


func _update_colors() -> void:
	var c := PALETTE.lookup(red, green, blue)
	var poly := ($Polygon2D as Polygon2D)
	c.a = poly.color.a
	poly.color = c
