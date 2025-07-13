extends Button


func _pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
