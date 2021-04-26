extends Sprite

export var type = 0 setget set_type

func set_type(val):
	type = val
	texture = ResMgr.blobs[type]
	update()

func _ready():
	material = material.duplicate()
	var mat = material as ShaderMaterial
	# Wind force and speed must be correlated or it's weird
	var wspeed = rand_range(1.5, 5.0)
	mat.set_shader_param('wind_speed', wspeed)
	mat.set_shader_param('wind_force', wspeed / 5 * .3 * rand_range(0.1, 1))
	mat.set_shader_param('wind_offset', rand_range(0.0, 2*PI))
	set_type(type)
