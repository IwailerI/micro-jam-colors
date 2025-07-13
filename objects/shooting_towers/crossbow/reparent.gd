extends CPUParticles2D


var target: Node2D


func _ready() -> void:
	setup.call_deferred()
	emitting = true


func setup() -> void:
	var p := get_parent()
	if p == null:
		return

	if not p.is_node_ready():
		await p.ready

	var pp := p.get_parent()
	p.remove_child(self)
	pp.add_child(self)

	p.tree_exiting.connect(func() -> void:
		if not is_inside_tree():
			return
		emitting = false
		get_tree().create_timer(lifetime).timeout.connect(queue_free)
	)

	target = p


func _physics_process(_delta: float) -> void:
	if target != null:
		global_transform = target.global_transform
