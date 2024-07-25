extends Node2D

class_name Level

signal unsolveable

#var board : Array[Array]
#var board_n : int

var colors : Array[Dictionary] = [
	{"color_name":"RED", "color_code": Color.RED},
	{"color_name":"BLUE", "color_code": Color.BLUE},
	{"color_name":"GREEN", "color_code": Color.GREEN},
	{"color_name":"YELLOW", "color_code": Color.YELLOW},
	{"color_name":"ORANGE", "color_code": Color.ORANGE},
	{"color_name":"PURPLE", "color_code": Color.PURPLE},
	{"color_name":"PINK", "color_code": Color.PINK},
	{"color_name":"BROWN", "color_code": Color.BROWN},
	{"color_name":"CYAN", "color_code": Color.CYAN},
	{"color_name":"MAGENTA", "color_code": Color.MAGENTA},
	{"color_name":"GRAY", "color_code": Color.GRAY}
]

func _ready() -> void:
	colors.shuffle()
	#board_n = board.size()

func mark_cell_as_queens(board, cell:Cell):
	var board_n : int = board.size()
	if cell and colors:
		var color : Dictionary = colors.pop_back()
		cell.selected_as_querens(color)
		var select_row : int = cell.row
		var select_col : int = cell.col
		for i in range(0, board_n):
			board[i][select_col].mark_as_cant_queens()
			board[select_row][i].mark_as_cant_queens()
		
		var adjacent_cells := Level.get_adjacent_cells(cell, board)
		for j in adjacent_cells:
			j.mark_as_cant_queens()
		

static func get_adjacent_cells(cell, board) -> Array:
	var board_n : int = board.size()
	var adjacent_cells := []
	for i in [-1, 0, 1]:
		for j in [-1, 0, 1]:
			var mark_cell = board[clampi(cell.row+i, 0, board_n-1)][clampi(cell.col+j, 0, board_n-1)]
			if (mark_cell != cell) and (mark_cell not in adjacent_cells):
				adjacent_cells.append(mark_cell)
	#print (adjacent_cells)
	return adjacent_cells

func get_imediate_adjacent_cells(cell, board) -> Array:
	var board_n : int = board.size()
	var adjacent_cells := []
	for i in [-1, 0, 1]:
		for j in [-1, 0, 1]:
			if abs(i + j) == 1 :
				var mark_cell = board[clampi(cell.row+i, 0, board_n-1)][clampi(cell.col+j, 0, board_n-1)]
				if (mark_cell != cell) and (mark_cell not in adjacent_cells):
					adjacent_cells.append(mark_cell)
	return adjacent_cells


func assign_queens(board):
	### Assign queens for each col and row ### 
	var successfully_selected_all_queens := true
	var board_n : int = board.size()
	for i in range(0, board_n):
		var next_row = board[i]
		next_row = next_row.filter(func(cell): return cell.can_queen)
		if !next_row:
			successfully_selected_all_queens = false
			break
		var select_cell_to_queen = next_row.pick_random()
		mark_cell_as_queens(board, select_cell_to_queen)
	
	var color_groups := []
	if !successfully_selected_all_queens:
		unsolveable.emit()
	else:
		for i in range(0, board_n):
			var queen : Cell = board[i].filter(func(cell): return cell.is_queen)[0]
			for group in queen.get_groups():
				if not str(group).begins_with("_") and str(group) != 'cells':
					color_groups.append(group)
	return color_groups


func find_an_imedidate_adjacent_cell_and_fill_color(color_group_pop, board):
	var random_selected_cell_in_group_pop : Cell = get_tree().get_nodes_in_group(color_group_pop).pick_random()
	var adjacent_cells_pop := get_imediate_adjacent_cells(random_selected_cell_in_group_pop, board)
	adjacent_cells_pop = adjacent_cells_pop.filter(func(cell): return !cell.is_occupied and !cell.is_queen)
	if adjacent_cells_pop:
			var random_adjacent_cells_pop : Cell = adjacent_cells_pop.pick_random()
			random_adjacent_cells_pop.assign_color({"color_name":color_group_pop, "color_code": Color(color_group_pop)})
			random_adjacent_cells_pop.add_to_group(color_group_pop)
			random_adjacent_cells_pop.set_occupied()
			return true 

func generate_level(board):
	var color_groups : Array  = assign_queens(board)
	if color_groups.size() > 0:
		var board_n : int = board.size()
		var no_of_cell_to_be_filled := board_n * board_n - board_n
	
		## Picked at least half colors to have half cells
		var i := 0
		for number_of_color_group_popped in range(ceil(board_n/2.0)): #5: 2
			var color_group_pop : String = color_groups.pop_back()
			for size_of_color_group in range((board_n-ceil(board_n/2.0))-1): #5: 1
				if find_an_imedidate_adjacent_cell_and_fill_color(color_group_pop, board):
					no_of_cell_to_be_filled -= 1
					i += 1

		## Picked at least half colors to have half cells
		#var j := 0
		#for number_of_color_group_popped in range(floor(board_n/3.0)): #5: 2
			#var color_group_pop : String = color_groups.pop_back()
			#for size_of_color_group in range((floor(board_n/3.0))-1): #5: 1
				#if find_an_imedidate_adjacent_cell_and_fill_color(color_group_pop, board):
					#no_of_cell_to_be_filled -= 1
					#j += 1
					#
					
		## Fill the rest of the board ### 
		var number_of_loop := 0
		while no_of_cell_to_be_filled > 0 and number_of_loop < 2 * (board_n * board_n - board_n):
			number_of_loop += 1
			var color_group : String = color_groups.pick_random()
			#print ('\nOn :' + str(color_group))
			if find_an_imedidate_adjacent_cell_and_fill_color(color_group, board):
				no_of_cell_to_be_filled -= 1
		
		#print ('i target ' + str(ceil(board_n/2.0)) + ' : ' + str((board_n-ceil(board_n/2.0))))
		#print ('j target ' + str(floor(board_n/3.0)) + ' : ' + str((floor(board_n/3.0))))
		if no_of_cell_to_be_filled != 0 or i < ceil(board_n/2.0):# or j < floor(board_n/3.0):
			unsolveable.emit()
		#if i < 10:
			#unsolveable.emit()

			#finished_generated()


