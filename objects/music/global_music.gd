extends AudioStreamPlayer

func _ready() -> void:
	stream = load("res://sounds/ost/ost_no_begin_pause.wav") as AudioStream
	bus = "Music"
	process_mode = Node.PROCESS_MODE_ALWAYS
