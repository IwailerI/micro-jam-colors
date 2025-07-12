extends Node2D

const POTION_PREFAB := preload("res://objects/potion/potion.tscn")

@export_category("Color values")
@export_range(0, 1) var red: int
@export_range(0, 1) var green: int 
@export_range(0, 1) var blue: int

@export_category("Brewing values")
@export_range(1, 60) var brewing_time: int

@onready var respawn_progressbar: TextureProgressBar = $RespawnProgressBar

var respawn_timer: Timer


func _ready() -> void:
	assert(red == 1 || green == 1 || blue == 1)
	respawn_timer = $RespawnTimer
	respawn_timer.timeout.connect(_finish_brewing)
	_start_brewing()


func _start_brewing() -> void:
	respawn_timer.start(brewing_time)
	respawn_progressbar.visible = true


func _process(_delta: float) -> void:
	respawn_progressbar.value = respawn_timer.time_left / brewing_time


func _finish_brewing() -> void:
	respawn_progressbar.visible = false
	var potion_node := POTION_PREFAB.instantiate()
	potion_node.red = red
	potion_node.green = green
	potion_node.blue = blue
	potion_node.tree_exited.connect(_start_brewing)
	add_child(potion_node)
