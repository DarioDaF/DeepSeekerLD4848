class_name Cell
extends Node2D

# DO NOT ALTER Pools form outside, just set them!
export var blobs: PoolIntArray setget set_blobs
export var hooks: PoolIntArray setget set_hooks

export var canFocus = true
export var focusTime = 0.8
export var focusZoom = 1.5

export var deadly = false setget set_deadly
export var status = '' setget set_status

onready var blob_container = $Outer/BlobContainer
onready var deadly_sprite = $Deadly
onready var status_sprite = {
	'ok': $OK,
	'oot': $OOT
}
onready var outer = $Outer
onready var inner = $Outer/Inner
var Blob = preload('res://Cell/Blob.tscn')

var focused = false

var inner_speed = 0
var outer_speed = 0

export var inner_type = 0 setget set_inner_type;
export var outer_type = 0 setget set_outer_type;

signal clicked

func copy_data_to(target: Cell):
	target.blobs = blobs
	target.hooks = hooks
	target.inner_type = inner_type
	target.outer_type = outer_type
	target.inner_speed = inner_speed
	target.outer_speed = outer_speed
	target.deadly = deadly
	target.status = status
	# Reroll all randomness (blob wind is rerolled by set_blobs)
	target.inner_speed = rand_range(-1.0, 1.0)
	target.outer_speed = rand_range(-0.5, 0.5)

func set_status(val):
	status = val
	if status_sprite:
		for k in status_sprite:
			status_sprite[k].visible = k == status

func set_deadly(val):
	deadly = val
	if deadly_sprite:
		deadly_sprite.visible = deadly

func set_hooks(val):
	hooks = val
	if outer:
		outer.hooks = hooks
		outer.update()

func set_outer_type(val):
	outer_type = val
	if outer:
		outer.texture = ResMgr.cell_outer[outer_type]
		outer.update()

func set_inner_type(val):
	inner_type = val
	if inner:
		inner.texture = ResMgr.cell_inner[inner_type]
		inner.update()

func set_blobs(val):
	blobs = val
	if blob_container and outer:
		for children in blob_container.get_children():
			(children as Node2D).queue_free()
		var n_blobs = len(blobs)
		for i in range(n_blobs):
			var blob = Blob.instance()
			blob.type = blobs[i]
			blob.rotation = i*2*PI / n_blobs
			blob_container.add_child(blob)
		outer.n_blobs = len(blobs)
		outer.update()

func _ready():
	inner_speed = rand_range(-1.0, 1.0)
	outer_speed = rand_range(-0.5, 0.5)
	set_inner_type(inner_type)
	set_outer_type(outer_type)
	set_blobs(blobs)
	set_hooks(hooks)
	set_deadly(deadly)
	set_status(status)

func _process(delta):
	outer.rotate(delta * outer_speed)
	inner.rotate(delta * inner_speed)
	if canFocus:
		var realZoom = focusZoom if focused else 1.0
		var zoomDelta = delta / focusTime
		var currZoom = outer.scale.x
		if realZoom > currZoom:
			currZoom += zoomDelta
			if currZoom >= realZoom:
				currZoom = realZoom
			outer.scale = Vector2(currZoom, currZoom)
		elif realZoom < currZoom:
			currZoom -= zoomDelta
			if currZoom < 1:
				currZoom = 1
			outer.scale = Vector2(currZoom, currZoom)

func _on_Focus_input_event(_viewport, event: InputEvent, _shape_idx):
	var eBtn = event as InputEventMouseButton
	if eBtn:
		if eBtn.pressed == true and eBtn.button_index == BUTTON_LEFT:
			emit_signal('clicked', self)

func _on_Focus_mouse_entered():
	focused = true
	z_index = 1

func _on_Focus_mouse_exited():
	focused = false
	z_index = 0
