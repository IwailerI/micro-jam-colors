extends Area2D

## Called when player entered the delivery point while not having enough colors to win.
signal warning_popup

@export_category("Color requirement")
@export_range(0, GameManager.MAX_COLOR_VALUE) var red: int
@export_range(0, GameManager.MAX_COLOR_VALUE) var green: int 
@export_range(0, GameManager.MAX_COLOR_VALUE) var blue: int 
@export var broken_requirement_message: String = "too many colors"

var gm: GameManager


func _ready() -> void:
	gm = GameManager.get_instance()
	gm.added_colors.connect(_on_added_colors)


func _on_added_colors(r: int, g: int, b: int) -> void:
	if r > red: gm.gameover(false, broken_requirement_message)
	if g > green: gm.gameover(false, broken_requirement_message)
	if b > blue: gm.gameover(false, broken_requirement_message)


func _on_body_entered(_body: Node2D) -> void:
	if gm.red < red: warning_popup.emit()
	elif gm.green < green: warning_popup.emit()
	elif gm.blue < blue: warning_popup.emit()
	else: gm.gameover(true)
