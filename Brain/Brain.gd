extends Sprite

export var status = 0.0 setget set_status

onready var full = $Full

signal focused(val)

func set_status(val):
	status = val
	modulate = Color.red if status > 1.0 else Color.white
	if full:
		(full.material as ShaderMaterial).set_shader_param('filling', val)
		full.update()

func _ready():
	set_status(status)

func _on_Area2D_mouse_entered():
	emit_signal('focused', true)

func _on_Area2D_mouse_exited():
	emit_signal('focused', false)
