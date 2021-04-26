extends Sprite

var n_blobs = 0
var hooks: PoolIntArray

func _draw():
	if n_blobs <= 0:
		return
	for hook in hooks:
		var base_angle = (hook-.5)*2*PI / n_blobs
		var v = Vector2(1, 0).rotated(base_angle)
		var poly = [
			(v * 320).rotated(-0.02),
			(v * 320).rotated(0.00),
			(v * 320).rotated(0.02),
			(v * 300).rotated(0.1),
			(v * 280).rotated(0.02),
			(v * 100)
		]
		draw_colored_polygon(poly, Color.black)
		#draw_polyline(poly, Color.white, 2) # Bad looking when scaled
