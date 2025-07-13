extends VBoxContainer

const LEVELITEM: PackedScene = preload("res://scenes/mainmenu/level_item.tscn")


func _ready() -> void:
	var furthest_num: int = Persistance.get_furthest_id() + 1
	for level_id in furthest_num:
		var inst := LEVELITEM.instantiate()
		var label := inst.get_child(0) as Label
		label.text = str(level_id + 1)
		var button := inst.get_child(1) as LevelSelectionItemButton
		button.text = Persistance.LEVEL_NAME[level_id]
		button.level_id = level_id
		add_child(inst)
