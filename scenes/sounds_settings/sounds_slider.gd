extends HSlider


@export var bus_id: int


func _ready() -> void:
	value = Persistance.get_volume(bus_id)
	AudioServer.set_bus_volume_linear(bus_id, value)
	drag_ended.connect(_draged_ended)


func _draged_ended(value_changed: bool) -> void:
	if value_changed:
		Persistance.set_volume(bus_id, value)
		AudioServer.set_bus_volume_linear(bus_id, value)
