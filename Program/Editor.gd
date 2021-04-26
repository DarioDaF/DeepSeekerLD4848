extends Node2D

export var max_oriz_blocks = 10
var program = '' setget set_program
var cursor = 0 setget set_cursor

var enabled = true setget set_enabled # To disable edit while running

func set_enabled(val):
	enabled = val
	modulate = Color.white if enabled else Color(0.7, 0.7, 0.7, 1.0)

onready var prog_container = $Program
onready var cursor_sprite = $Cursor

signal program_changed

func reset():
	self.cursor = 0
	self.enabled = true
	self.program = ''

func set_program(val):
	program = val
	emit_signal('program_changed')
	# Rerender blocks
	if prog_container:
		for children in prog_container.get_children():
			(children as Node2D).queue_free()
		var i = 0
		for c in program:
			var s = Sprite.new()
			s.position = Vector2((i % max_oriz_blocks), (i / max_oriz_blocks)) * 620
			s.texture = ResMgr.instructions[c]
			prog_container.add_child(s)
			i += 1

func set_cursor(val):
	cursor = val
	if cursor_sprite:
		cursor_sprite.position = Vector2((cursor % max_oriz_blocks), (cursor / max_oriz_blocks)) * 620

func _input(event):
	if enabled:
		var eKbd = event as InputEventKey
		if eKbd:
			if eKbd.pressed:
				var k = ResMgr.unicode_to_char(eKbd.unicode)
				if k in ResMgr.instructions:
					add_instr(k)
				elif program != '':
					if eKbd.scancode == KEY_BACKSPACE and cursor > 0:
						var p = program.left(cursor-1) + program.right(cursor)
						self.program = p
						self.cursor -= 1
					elif eKbd.scancode == KEY_DELETE and cursor < len(program):
						var p = program.left(cursor) + program.right(cursor+1)
						self.program = p
					elif eKbd.scancode == KEY_RIGHT and cursor < len(program):
						self.cursor += 1
					elif eKbd.scancode == KEY_LEFT and cursor > 0:
						self.cursor -= 1

func add_instr(k):
	if enabled:
		var p = program.left(cursor) + k + program.right(cursor)
		self.program = p
		self.cursor += 1

func _ready():
	set_program(program)
	set_cursor(cursor)
