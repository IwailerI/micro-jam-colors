extends Node2D

const POTION := preload("res://objects/potion/potion.tscn")
const PALETTE := preload("res://objects/palette/default.tres")

@export_group("Color values")
@export var cyan: bool
@export var magenta: bool
@export var yellow: bool

@export_group("Brewing values")
@export_range(1, 60) var brewing_time: int

@onready var respawn_progressbar: TextureProgressBar = $RespawnProgressBar

var respawn_timer: Timer


func _ready() -> void:
	assert(cyan or magenta or yellow, "colorless potion spawner")

	respawn_timer = $RespawnTimer
	respawn_timer.timeout.connect(_finish_brewing)

	var c := PALETTE.lookup(cyan, magenta, yellow)
	var poly := ($Polygon2D as Polygon2D)
	c.a = poly.color.a
	poly.color = c

	_start_brewing()


func _start_brewing() -> void:
	if not respawn_timer.is_inside_tree():
		await respawn_timer.tree_entered
	respawn_timer.start(brewing_time)
	respawn_progressbar.visible = true
	print(respawn_timer)


func _process(_delta: float) -> void:
	respawn_progressbar.value = 1.0 - respawn_timer.time_left / brewing_time


func _finish_brewing() -> void:
	respawn_progressbar.visible = false
	var potion_node := POTION.instantiate()
	potion_node.cyan = cyan
	potion_node.magenta = magenta
	potion_node.yellow = yellow
	potion_node.tree_exited.connect(_start_brewing)
	add_child(potion_node)
