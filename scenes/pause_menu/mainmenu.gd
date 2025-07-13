extends Button

const MAINMENU_SCENE: PackedScene = null


func _pressed() -> void:
	get_tree().paused = false
	assert(is_instance_valid(MAINMENU_SCENE))
	get_tree().change_scene_to_packed(MAINMENU_SCENE)
