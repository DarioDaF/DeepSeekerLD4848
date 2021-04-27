extends Node

const data = [
	#{
	#	name = 'Tutorial',
	#	pitch = 0.2,
	#	max_time = 100.0,
	#	max_brain = 30.0,
	#	cells = [
	#		# First cell is deadly by default
	#		{
	#			blobs = [0, 0, 0, 0],
	#			hooks = [0]
	#		}
	#	],
	#	text = [
	#		'This is a [color=#44F][b]custom level™[/b][/color] to make a short video to explain the UI',
	#		'I think the interface and tutorial can use some [color=#888](a lot of)[/color] work, but the puzzles were more intriguing than I expected.',
	#		'Thanks you all for commenting your opinions [color=#F00][b]<3[/b][/color]❣'
	#	],
	#	end_text = 'Have a [b]nice day[/b]!'
	#},
	{
		name = 'Intro',
		pitch = 1.0,
		max_time = 100.0,
		max_brain = 30.0,
		cells = [
			# First cell is deadly by default
			{
				blobs = [0, 0, 0, 0],
				hooks = [0]
			}
		],
		text = [
			"""Welcome to [color=#44F][b]μhardwer™[/b][/color] we develop the future and you are part of us
[/center][i][color=#888]Press space or click to continue...[/color][/i][center]""",
			'Your new job is in the laboratory, here we develop nanobots to attack harmful cells',
			'As you see [b]in the bottom left[/b] you have a list of cells present in the compound we are trying to clean',
			'The target cell is identified by the [b]scull[/b] icon',
			'On the bottom right you see the complexity of the bot you are developing and the time it takes to identify the cells',
			'Your bot should not harm [b]non target[/b] cells included in the list',
			'The instructions of your bot are on the center [color=#888][i](refer to lab equipment user manual below)[/i][/color]',
			'Your first task is to make a cleansing agent, for this task you will find ref. in the documentation',
			# Last text message (idle) will not be shown if the user already solved
			# don't use it for lore and such...
			'Feel free to experiment, we are working [b]in lab[/b] now, nothing critical...'
		],
		end_text = 'It\'s ok to go by the book, sometime the best solution is the simplest'
	},
	{
		name = 'SimpleCells',
		pitch = 2.0,
		max_time = 100.0,
		max_brain = 30.0,
		cells = [
			{
				blobs = [0, 0, 0, 1],
				hooks = [0]
			},
			{
				blobs = [1, 0, 0, 0],
				hooks = [0]
			}
		],
		text = [
			'This time we need to distinguish chiral compounds',
			'Sometimes the solution is easyer than it seems',
			'Some other there is a trick to shorten the code, not that it matters now',
		],
		end_text = 'Ok job, let\'s move to something more useful'
	},
	{
		name = 'ReverseCheck',
		pitch = 1.5,
		max_time = 100.0,
		max_brain = 10.0,
		cells = [
			{
				blobs = [0, 0, 0, 0, 0],
				hooks = [0]
			},
			{
				blobs = [0, 1, 0, 0, 6, 0, 0, 0],
				hooks = [0]
			},
			{
				blobs = [0, 2, 0, 0, 6, 0, 0, 0],
				hooks = [0]
			},
			{
				blobs = [0, 3, 0, 0, 6, 0, 0, 0],
				hooks = [0]
			}
		],
		text = [
			'In this jobs there are many markers that can distinguish targets, a good developer will know which is the easyest to exploit',
			'But a perfectionist might go for walk along another path and find something more complex',
			'If you feel like it try to go for the smallest program, researches say it\'s shorter than 10 instructions'
		],
		end_text = 'Nice work'
	},
	{
		name = 'NiceIce',
		pitch = 0.5,
		max_time = 12.0,
		max_brain = 30.0,
		cells = [
			{
				blobs = [2, 1, 2, 1, 2, 1],
				hooks = [0]
			},
			{
				blobs = [2, 2, 2, 2, 2, 2],
				hooks = [0]
			},
			{
				blobs = [1, 1, 1, 1, 1, 1],
				hooks = [0]
			}
		],
		text = [
			'Now it is the time for [b]real work[/b], we need to identify this cell',
			'This cell is very invasive and can even be contagious, take [b]precautions[/b]',
			"""I need to identify this cell [b]fast[/b]...

[color=#888]This feels dangerous[/color]"""
		],
		end_text = 'Well done, [i]but we have a problem[/i]'
	},
	{
		name = 'Deepest',
		pitch = 3.0,
		max_time = 20.0,
		max_brain = 25.0,
		cells = [
			{
				blobs = [2, 1, 2, 1, 2, 1],
				hooks = [0]
			},
			{
				blobs = [2, 2, 2, 2, 2, 2],
				hooks = [0]
			},
			{
				blobs = [1, 1, 1, 1, 1, 1],
				hooks = [0]
			},
			{
				blobs = [3, 2, 3, 2, 3, 2],
				hooks = [0]
			},
			{
				blobs = [2, 1, 2, 1, 2, 0],
				hooks = [0]
			}
		],
		text = [
			'Unfortunately the cell under test was exposed by someone to [b]open air[/b]',
			'We need to use your compound to limit the spread',
			'The problem is that we need to go [b]deeper[/b], into living organisms',
			"""There are a lot of compounds we [b]must[/b] not interfere with

This won't be easy, good luck"""
		],
		end_text = 'Thanks to you we were able to block completely the cell'
	}

]
