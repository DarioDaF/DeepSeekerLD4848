extends Node2D

const DEBUG = false # @TODO: Set to false before release

var Cell = preload('res://Cell/Cell.tscn')

var level = 0
var text_progress = -1

var max_time = 1.0
var max_brain = 1.0

var sel_time = 0
var all_ok = false

var hint_type = ''

func create_cell() -> Cell:
	var cell = Cell.instance()
	cell.inner_type = randi() % len(ResMgr.cell_inner)
	cell.outer_type = randi() % len(ResMgr.cell_outer)
	#var blobs = []
	#var n_blobs = randi() % 8 + 5
	#for _i in range(n_blobs):
	#	blobs.append(randi() % len(ResMgr.blobs))
	#cell.blobs = PoolIntArray(blobs)
	#var x = []
	#for _i in range(2):
	#	x.append(randi() % n_blobs)
	#cell.hooks = PoolIntArray(x)
	return cell

func _cell_clicked(c: Cell):
	c.copy_data_to($Cell)
	$Cell.outer_speed *= 0.1
	update_big_cell()

func load_state():
	var saveFile = File.new()
	if saveFile.file_exists(ResMgr.GAMESTATE_STORE):
		saveFile.open(ResMgr.GAMESTATE_STORE, File.READ)
		var data = parse_json(saveFile.get_line())
		if data['level']:
			level = int(data['level'])
		saveFile.close()

func save_state():
	var saveFile = File.new()
	saveFile.open(ResMgr.GAMESTATE_STORE, File.WRITE)
	var data = to_json({
		'level': level
	})
	saveFile.store_line(data)
	saveFile.close()

func update_text_status():
	var clevel = Levels.data[level]
	$Text/Continue.visible = false
	$Text/Next.visible = false
	$Text/Text.bbcode_text = '[center]' + clevel['text'][text_progress] + '[/center]'
	if text_progress+1 < len(clevel['text']):
		$Text/Continue.visible = true
	else:
		if all_ok:
			$Text/Text.bbcode_text = '[center]' + clevel['end_text'] + '[/center]'
			$Text/Next.visible = true

func advance_text():
	var clevel = Levels.data[level]
	if text_progress+1 < len(clevel['text']):
		text_progress += 1
		update_text_status()
	elif all_ok:
		if level+1 < len(Levels.data):
			level += 1
			load_level()
		else:
			get_tree().change_scene("res://EndGame.tscn")

func load_level():
	save_state()
	var clevel = Levels.data[level]
	max_time = clevel['max_time']
	max_brain = clevel['max_brain']
	for cell in $CellList.get_children():
		cell.queue_free()
	var ccells = clevel['cells']
	for i in range(len(ccells)):
		var c = create_cell()
		c.blobs = PoolIntArray(ccells[i]['blobs'])
		c.hooks = PoolIntArray(ccells[i]['hooks'])
		c.connect('clicked', self, '_cell_clicked')
		c.scale = Vector2(0.14, 0.14)
		c.position.x = i * 140
		$CellList.add_child(c)
		if i == 0:
			c.deadly = true
			_cell_clicked(c)
	text_progress = -1
	advance_text()
	$AudioBlins.pitch_scale = Levels.data[level]['pitch']
	#$AudioBG.pitch_scale = Levels.data[level]['pitch'] #???
	$Editor.reset() # Causes all_ok to be recomputed

func _process(delta):
	#$AudioBlins.position = get_global_mouse_position()
	# @TODO: Fix or bypass only in html export and handle trough JS
	# and browser handlers (<audio>)
	pass

func _ready():
	randomize()
	load_state()
	load_level()

func _on_Program_pressed(inst):
	$Editor.add_instr(inst)

func update_cells_status():
	VM.program = $Editor.program
	VM.max_steps = max_time
	sel_time = 0
	all_ok = true
	for cell in $CellList.get_children():
		if not VM.test_cell(cell):
			all_ok = false
	update_big_cell()
	update_text_status() # propagate all_ok update

func update_big_cell():
	VM.test_cell($Cell, true)
	$Cell/DataRing.slots = VM.slots
	$Cell/DataRing.selected_slot = VM.bc
	$Cell/DataRing.update()
	sel_time = max(VM.steps, sel_time)
	update_hint() # propagate sel_time update

func _input(event):
	var eKbd = event as InputEventKey
	if eKbd:
		if eKbd.pressed and eKbd.scancode == KEY_SPACE:
			advance_text()
		if eKbd.pressed and eKbd.scancode == KEY_0:
			level = 0
			load_level()
		if DEBUG:
			if eKbd.pressed and eKbd.scancode == KEY_D:
				$Editor.enabled = not $Editor.enabled
			if eKbd.pressed and eKbd.scancode == KEY_O:
				$CellList.get_child(0).status = 'ok'
			if eKbd.pressed and eKbd.scancode == KEY_P:
				$CellList.get_child(0).status = 'oot'
			if eKbd.pressed and eKbd.scancode == KEY_Q:
				$CellList.get_child(0).status = ''
			if eKbd.pressed and eKbd.scancode == KEY_R:
				update_cells_status()

func _on_ColorRect_gui_input(event):
	var eBtn = event as InputEventMouseButton
	if eBtn:
		if eBtn.pressed and eBtn.button_index == BUTTON_LEFT:
			advance_text()

func _on_Editor_program_changed():
	update_cells_status()

func update_hint():
	$Stats/Brain.status = len($Editor.program) / max_brain
	$Stats/Clock.status = sel_time / max_time
	$Stats/Hint/Text.text = ''
	if hint_type == 'brain':
		$Stats/Hint/Text.text = str(len($Editor.program)) + ' / ' + str(max_brain)
	elif hint_type == 'time':
		if sel_time > VM.REAL_MAX_STEPS:
			$Stats/Hint/Text.text = str(VM.REAL_MAX_STEPS) + '+ / ' + str(max_time)
		else:
			$Stats/Hint/Text.text = str(sel_time) + ' / ' + str(max_time)
	$Stats/Hint.visible = hint_type != ''

func _on_Brain_focused(val):
	hint_type = 'brain' if val else ''
	update_hint()

func _on_Clock_focused(val):
	hint_type = 'time' if val else ''
	update_hint()
