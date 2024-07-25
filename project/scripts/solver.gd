extends Node2D

var board : Array[Array] = []

func set_up(_board):
	board = _board

func get_solution():
	# Give you a list of possible solution
	print ('Finding solutions')
	var one_cell := one_cell_rule()
	if not one_cell:
		var two_cells_h := two_cells_h_rule()
		if not two_cells_h:
			var two_cells_v := two_cells_v_rule()
			if not two_cells_v:
				pass
			
	## 3. find verical color groups
	## 3.1 mark col as 'x'
	
	## 4. find horizontal color groups
	## 4.1 mark row as 'x'
	
	## 5. find corner color groups that have only 3 cells
	## 5.1 mark 3 adjacent cells as 'x'
	
	## 6. find corner color groups that have 'L' shape cells
	## 6.1 mark 1 adjacent cells as 'x'
	
	## 7. find avalible cells in row
	## 7.1  mark common adjacent cell as 'x'
	
	## 8. find avalible cells in col
	## 8.1  mark common adjacent cell as 'x'

	## 8. find avalible cells in color group
	## 8.1  mark common adjacent cell as 'x'
	
	## 9. find N complementary color group for col
	## 9.1 find color group that only have N avalible cells vertically 
	## 9.2 if there exist another color group that only have N avalible cells vertically and in the same row level
	## 9.3  mark all other cells on the same row level  as 'x'
	
	## 10. find N complementary color group for row
	## 10.1 find color group that only have N avalible cells horizontally 
	## 10.2 if there exist another color group that only have N avalible cells horizontally and in the same row level
	## 10.3  mark all other cells on the same row level  as 'x'
	return board 

func find_cells_in_same_color_group(cell:Cell):
	var cells = AnswerChecker.transpose_array_by_group(board, 'dictionary')
	return cells[cell.color_name]
	
func find_cells_in_same_row(cell: Cell):
	print (board[cell.row])
	return board[cell.row]
			
func find_cells_in_same_col(cell: Cell):
	var cells = AnswerChecker.transpose_array(board)
	print (cells[cell.col])
	return cells[cell.col]
	
	
func apply_x(cell: Cell):
	if cell.current_state == 'empty':
		cell.change_to_next_state()
	elif cell.current_state == 'crown':
		apply_stripe(cell)

func apply_stripe(cell : Cell):
	if cell.current_state == 'crown':
		cell.change_to_next_state()

func apply_crown(cell : Cell):
	if cell.current_state == 'empty':
		cell.current_state = 'x'
		cell.change_to_next_state()

	var same_row_cells : Array = find_cells_in_same_row(cell)
	for same_row_cell in same_row_cells:
		if same_row_cell != cell:
			apply_x(same_row_cell)
			
	var same_col_cells : Array = find_cells_in_same_col(cell)
	for same_col_cell in same_col_cells:
		if same_col_cell != cell:
			apply_x(same_col_cell)
				
	var adjacent_cells : Array = Level.get_adjacent_cells(cell, board)
	for cells in adjacent_cells:
		apply_x(cells)
		
	var same_color_cells :Array = find_cells_in_same_color_group(cell)
	for same_color_cell in same_color_cells:
		if same_color_cell != cell:
			apply_x(same_color_cell)
	#cell(1, 4)

func one_cell_rule() -> bool:
	print ('1. Checking one cell')
	## 1. find color groups that have only 1 cell
	var board_c = AnswerChecker.transpose_array_by_group(board)
	for color_group in board_c:
		color_group = color_group.filter(func(cell): return cell.current_state == 'empty')
		if color_group.size()  == 1:
			var one_celler : Cell = color_group[0]
			print ('One cell group found for ' + str(one_celler.color_name))
			apply_crown(one_celler)
			return true
	return false
	
func two_cells_h_rule() -> bool:
	print ('2. Checking two cells H')
	## 2. find color groups that have only 2 cells horizontally
	var board_c = AnswerChecker.transpose_array_by_group(board)
	for color_group in board_c:
		color_group = color_group.filter(func(cell): return cell.current_state == 'empty')
		if color_group.size() == 2:
			var check_next_to_each_other = (func(group): return group[1].col - group[0].col == 1)
			if check_next_to_each_other.call(color_group):
				print ('Two cell h group found for ' + str(color_group[0].color_name))
				for cell in color_group:
					var buttom_cell = board[clampi(cell.row-1, 0, board.size()-1)][cell.col]
					if buttom_cell != cell:
						apply_x(buttom_cell)
					var top_cell = board[clampi(cell.row+1, 0, board.size()-1)][cell.col]
					if top_cell != cell:
						apply_x(top_cell)
				# fill entire row
				for same_row_cell in find_cells_in_same_row(color_group[0]):
					if same_row_cell.color_name != color_group[0].color_name:
						apply_x(same_row_cell)
	return false
		#
func two_cells_v_rule() -> bool:
	print ('3. Checking two cells V')
	## 3. find color groups that have only 2 cells vertically
	var board_c = AnswerChecker.transpose_array_by_group(board)
	for color_group in board_c:
		color_group = color_group.filter(func(cell): return cell.current_state == 'empty')
		if color_group.size() == 2:
			var check_next_to_each_other = (func(group): return group[1].row - group[0].row == 1)
			if check_next_to_each_other.call(color_group):
				print ('Two cell v group found for ' + str(color_group[0].color_name))
				for cell in color_group:
					var left_cell = board[cell.row][clampi(cell.col-1, 0, board.size()-1)]
					if left_cell != cell:
						apply_x(left_cell)
					var right_cell = board[cell.row][clampi(cell.col+1, 0, board.size()-1)]
					if right_cell != cell:
						apply_x(right_cell)
				# fill entire col
				for same_col_cell in find_cells_in_same_col(color_group[0]):
					if same_col_cell.color_name != color_group[0].color_name:
						apply_x(same_col_cell)
	return false











