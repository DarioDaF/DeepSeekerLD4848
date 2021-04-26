extends Node2D

func _on_Label_meta_clicked(meta):
	OS.shell_open(meta)

export var dist = 1.5

var angle = 0.0
const ANG_SPEED = 0.2

func _ready():
	$Cell.inner_type = randi() % len(ResMgr.cell_inner)
	$Cell.outer_type = randi() % len(ResMgr.cell_outer)

func _process(delta):
	var c = Vector2(1024, 600) / 2
	angle += delta * ANG_SPEED
	if angle > 2*PI:
		angle -= 2*PI
	var d = Vector2(1, 0).rotated(angle) * dist * c
	$Cell.position = c + d


func _on_Button_pressed():
	var d = Directory.new()
	d.remove(ResMgr.GAMESTATE_STORE)
	get_tree().change_scene("res://Play.tscn")
