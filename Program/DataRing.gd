extends Node2D

var SlotFont = preload('SlotFont.tres')

export var inner_r = 300
export var outer_r = 350

var slots = [0, 0] # MUST BE AT LEAST 2
var selected_slot = 0 # Should update after change (or use setters)

func _process(_delta):
	rotation = get_node('../Outer').rotation

func _draw():
	var n_slots = len(slots)
	var delta = PI/n_slots
	for slot in range(n_slots):
		var base_angle = slot*2*PI/n_slots
		var vn = Vector2(1, 0).rotated(base_angle - delta)
		var v0 = Vector2(1, 0).rotated(base_angle)
		var vp = Vector2(1, 0).rotated(base_angle + delta)
		var shape = [
			vn * outer_r,
			v0 * outer_r,
			vp * outer_r,
			vp * inner_r,
			v0 * inner_r,
			vn * inner_r
		]
		draw_colored_polygon(shape, Color(0.5, 0.5, 0.5, 0.8))
		draw_polyline(shape, Color.black, 1.0)
		if selected_slot == slot:
			draw_polyline(shape.slice(0, 2), Color.red, 6.0)
			draw_polyline(shape.slice(3, 5), Color.red, 6.0)
		var center = v0 * (outer_r + inner_r) / 2
		var box = SlotFont.get_string_size(str(slots[slot]))
		draw_set_transform(center, base_angle + PI/2, Vector2.ONE)
		draw_string(SlotFont, Vector2(-box.x, box.y)/2, str(slots[slot]))
		draw_set_transform_matrix(Transform2D.IDENTITY)
