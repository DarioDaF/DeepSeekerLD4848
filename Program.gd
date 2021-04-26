extends Node2D

signal pressed(inst)

func _instr_pressed(instr):
	emit_signal("pressed", instr)

func _ready():
	var i = 0
	for k in ResMgr.instructions:
		var b = TextureButton.new()
		b.texture_normal = ResMgr.instructions[k]
		b.focus_mode = Control.FOCUS_NONE # Otherwise they eat space bar
		b.set_position(Vector2((i % 4)*58, (i / 4)*58))
		b.rect_scale = Vector2(0.09, 0.09)
		b.connect("pressed", self, "_instr_pressed", [ k ])
		add_child(b)
		i += 1
