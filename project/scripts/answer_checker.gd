extends Node2D

class_name AnswerChecker
@onready var rich_text_label: RichTextLabel = $RichTextLabel
const EARLY_GAME_BOY = preload("res://assets/fonts/Early GameBoy.ttf")


var fail_message := 'Red is too close to Green'


func check(board) -> bool:
	var check_adjacent := check_each_queen_not_touching_each_other(board)
	var borad_c = AnswerChecker.transpose_array_by_group(board)
	var check_color := check_each_group_contains_only_1_queen(borad_c, 'color')
	var board_t := AnswerChecker.transpose_array(board)
	var check_col := check_each_group_contains_only_1_queen(board_t, 'col')
	var check_row := check_each_group_contains_only_1_queen(board, 'row')
	var all_check := check_row and check_col and check_color and check_adjacent
	
	show_banner(check_row, check_col, check_color, check_adjacent, all_check)
	if all_check:
		return true
	else:
		return false

func show_banner(check_row, check_col, check_color, check_adjacent, all_check):
	var messages := ['[pulse]Checking rows... [/pulse]', 
					 '[pulse]Checking column... [/pulse]', 
					 '[pulse]Checking color region... [/pulse]', 
					 '[pulse]Checking adjacent cells... [/pulse]']
				
	var well_done_message = '\n\n[center][font_size=25][wave][color=green]All passed! Well done![/color][/wave][/font_size][/center]'
	
	var checks := [check_row, check_col, check_color, check_adjacent, all_check]
	var pass_ = '[color=green]PASS[/color]'
	var fail = '[color=red]FAIL[/color]'
	rich_text_label.bbcode_enabled = true
	rich_text_label.add_theme_font_override('normal_font',EARLY_GAME_BOY )
	
	rich_text_label.text = ''
	
	for i in range(messages.size()):
		rich_text_label.text = '%s' % messages[i]
		await get_tree().create_timer(1).timeout
		if checks[i]:
			rich_text_label.text += '%s\n' % pass_
			await get_tree().create_timer(0.5).timeout
		else:
			rich_text_label.text += '%s\n' % fail
			rich_text_label.text += '[color=white]%s[/color]' % fail_message
			await get_tree().create_timer(3).timeout
			break
	
	if all_check:
		rich_text_label.text = '%s\n' % well_done_message



	await get_tree().create_timer(3).timeout
	rich_text_label.text = ''


static func transpose_array(board:Array[Array]) -> Array[Array]:
	var n := len(board)
	var transposed : Array[Array] = []
	for i in range(n):
		transposed.append([])
	for i in range(n):
		for j in range(n):
			transposed[i].append(board[j][i])
	return transposed

static func transpose_array_by_group(board:Array[Array], return_type='array'):
	var color_groups := {}
	for row in board:
		for cell in row:
			var color : String = cell.color_name
			if color not in color_groups:
				color_groups[color] = []
			color_groups[color].append(cell)
	var color_group_array : Array[Array] = []
	for i in color_groups.values():
		color_group_array.append(i)
	if return_type == 'array':
		return color_group_array
	else:
		return color_groups

func check_each_group_contains_only_1_queen(board:Array[Array], groups:String) -> bool:
	var board_n := board.size()
	for group in range(0, board_n):
		var number_of_queen := 0
		for cell in board[group]:
			if cell.current_state == 'crown':
				number_of_queen += 1
				if number_of_queen > 1:
					if groups == 'color':
						fail_message = ('More than 1 queen in ' + groups + ' ' + ('[color=%s]%s[/color]') % [str(cell.color_name), str(cell.color_name)])
					else:
						fail_message = ('More than 1 queen in ' + groups + ' ' + str(group+1))
					return false
		if number_of_queen < 1:
			if groups == 'color':
				fail_message = ('No queen in ' + groups + ' ' + ('[color=%s]%s[/color]') % [str(board[group][0].color_name), str(board[group][0].color_name)])
			else:
				fail_message = ('No queen in ' + groups + ' ' + str(group+1))
			return false
	print ('Passed ' + groups + ' check')
	return true

func check_each_queen_not_touching_each_other(board:Array[Array]) -> bool:
	var board_n := board.size()
	for row in range(0, board_n):
		for cell in board[row]:
			if cell.current_state == 'crown':
				var cells_around_queen : Array = Level.get_adjacent_cells(cell, board)
				#print (cell.color_name + ' ' + str(cells_around_queen))
				for adjacent_cell in cells_around_queen:
					if adjacent_cell.current_state == 'crown':
						fail_message =  (('[color=%s]%s[/color]') % [cell.color_name, cell.color_name] + ' queen is too close to ' + ('[color=%s]%s[/color]') % [adjacent_cell.color_name,adjacent_cell.color_name] + ' queen')
						return false 
	print ('Passed adjacent cell check')
	return true
			
		
	#get_adjacent_cells(cell, board) -> Array:
	
	
