extends Node2D

const CELL = preload("res://scenes/cell.tscn")
const IMAGE_SIZE := 50

var game_area_size : float

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	var viewport_size_x : int = viewport_size.x
	var viewport_size_y : int = viewport_size.y
	game_area_size = min(viewport_size_x, viewport_size_y)


func new_board(board_n : int) -> Array[Array]:
	var board : Array[Array] = []
	var starting_position := Vector2.ZERO
	starting_position.x = (game_area_size-(board_n*IMAGE_SIZE))/2.0 + IMAGE_SIZE/2.0
	starting_position.y = (game_area_size-(board_n*IMAGE_SIZE))/2.0 + IMAGE_SIZE/2.0
	for row in range(board_n):
		var col_n : Array[Node] = []
		var new_cell_row := starting_position.x + row * IMAGE_SIZE
		
		for col in range(board_n):
			var cell : Cell = CELL.instantiate()
			var new_cell_col := starting_position.y + col * IMAGE_SIZE
			cell.position = Vector2(new_cell_col, new_cell_row)
			cell.name = 'cell_%d_%d' % [row, col]
			add_child(cell)
			#cell.set_debug_label('%d, %d' % [row, col])
			cell.set_row_col(row, col)
			col_n.append(cell)
		board.append(col_n)

	return board






