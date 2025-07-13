extends ConfirmationDialog


func _on_confirmed() -> void:
	Persistance.delete_progress()
	get_tree().reload_current_scene()


func _on_canceled() -> void:
	visible = false
