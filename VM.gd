extends Node

const REAL_MAX_STEPS = 150

var program: String
var blobs: PoolIntArray
var max_steps = 0

var slots: PoolIntArray

var start_hook = 0
var pc = 0 # Program counter
var bc = 0 # Blob counter

var steps = 0

var kill = false
var done = true

func test_cell(cell: Cell, deep = false):
	blobs = cell.blobs
	restart()
	run(deep)
	cell.status = ''
	if done:
		if kill == cell.deadly:
			cell.status = 'ok'
	else:
		cell.status = 'oot'
	return cell.status == 'ok'

func restart():
	kill = false
	pc = 0
	bc = start_hook
	slots.resize(len(blobs))
	for i in range(len(slots)):
		slots[i] = 0
	steps = 0
	done = false

func run(deep = false):
	while not done and steps <= (REAL_MAX_STEPS if deep else max_steps):
		step()

func match_depth(dir: bool):
	var idx = pc
	var depth = 1 if dir else -1
	while depth != 0:
		if dir:
			idx += 1
		else:
			idx -= 1
		if idx < 0 or idx >= len(program):
			return idx
		if program[idx] == '[':
			depth += 1
		elif program[idx] == ']':
			depth -= 1
	return idx

func step():
	if pc >= len(program):
		done = true
		return
	# Run instruction at pc
	var inst = program[pc]
	if inst == '>':
		bc += 1
		bc %= len(blobs)
	elif inst == '<':
		bc += len(blobs)-1
		bc %= len(blobs)
	elif inst == '+':
		slots[bc] += 1
	elif inst == '-':
		slots[bc] -= 1
	elif inst == ',':
		slots[bc] += blobs[bc]
	elif inst == '.':
		if slots[bc] != 0:
			kill = true
			done = true
	elif inst == '[':
		if slots[bc] == 0:
			pc = match_depth(true)
	elif inst == ']':
		if slots[bc] != 0:
			pc = match_depth(false)
	pc += 1
	steps += 1
