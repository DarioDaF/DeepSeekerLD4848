extends Node

var blobs = []
var cell_inner = []
var cell_outer = []
var instructions = {}

const GAMESTATE_STORE = 'user://lducell.save'

const _scancode_to_char = {
	KEY_GREATER: '>',
	KEY_LESS: '<',
	KEY_PLUS: '+',
	KEY_MINUS: '-',
	KEY_KP_ADD: '+',
	KEY_KP_SUBTRACT: '-',
	KEY_COMMA: ',',
	KEY_PERIOD: '.',
	KEY_KP_PERIOD: '.',
	KEY_BRACKETLEFT: '[',
	KEY_BRACKETRIGHT: ']'
}
func scancode_to_char(scancode):
	if scancode in _scancode_to_char:
		return _scancode_to_char[scancode]
	return OS.get_scancode_string(scancode)

func unicode_to_char(unicode):
	var res = char(unicode)
	if res == '4':
		return '<'
	elif res == '6':
		return '>'
	return res

const instruction_map = {
	'>': 'Next',
	'<': 'Prev',
	'+': 'Inc',
	'-': 'Dec',
	',': 'Look',
	'.': 'Kill',
	'[': 'OpenLoop',
	']': 'ClosedLoop'
}

func _ready():
	blobs.append(null)
	for i in range(1, 7):
		blobs.append(load('res://Cell/Blobs/' + str(i) + '.png'))
	for i in range(2):
		cell_inner.append(load('res://Cell/Cells/Inner/' + str(i) + '.png'))
	for i in range(2):
		cell_outer.append(load('res://Cell/Cells/Outer/' + str(i) + '.png'))
	for k in instruction_map:
		instructions[k] = load('res://Program/Instructions/' + instruction_map[k] + '.png')
