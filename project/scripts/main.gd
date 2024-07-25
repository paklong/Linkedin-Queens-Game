extends Node2D

signal cleared


const BOARD = preload("res://scenes/board.tscn")
const LEVEL = preload("res://scenes/level.tscn")
const ANSWER_CHECKER = preload("res://scenes/answer_checker.tscn")
const SOLVER = preload("res://scenes/solver.tscn")

@onready var check_answer_button: Button = %CheckAnswerButton
@onready var reset_button: Button = %ResetButton
@onready var new_game_button: Button = %NewGameButton
@onready var solver_button: Button = %SolverButton
@onready var music_button: Button = %MusicButton

#5 - 11
var game_level := 6
var current_board : Array[Array]

func _ready() -> void:
	check_answer_button.pressed.connect(check_answer)
	reset_button.pressed.connect(reset_state)
	new_game_button.pressed.connect(new_gmae)
	solver_button.pressed.connect(solve)
	new_gmae()
	
	check_answer_button.tooltip_text = 'Check Answer'
	reset_button.tooltip_text = 'Reset Level'
	new_game_button.tooltip_text = 'New Level'
	solver_button.tooltip_text = 'Show Hints'
	music_button.tooltip_text = 'Toggle Music'
	


	
func toggle_answer():
	get_tree().call_group('cells', 'show_debug_label')
	
func reset_state():
	get_tree().call_group('cells', 'reset_state')	
	
func new_gmae():
	for i in get_tree().get_nodes_in_group('boards'):
		i.queue_free()
	for i in get_tree().get_nodes_in_group('levels'):
		i.queue_free()
	
	check_no_board_and_level()
	await cleared
	
	var board := BOARD.instantiate()
	board.visible = false
	add_child(board)
	var _board = board.new_board(game_level)

	var level := LEVEL.instantiate()
	level.visible = false
	level.unsolveable.connect(_on_unsolveable)
	#level.board = _board
	add_child(level)
	level.generate_level(_board)
	
	board.visible = true
	level.visible = true
	
	current_board = _board
	

func check_answer():
	for i in get_tree().get_nodes_in_group('answer_checkers'):
		i.queue_free()
	var answer_checker := ANSWER_CHECKER.instantiate()
	answer_checker.z_index = 10
	add_child(answer_checker)
	answer_checker.check(current_board)


func solve():
	var solver := SOLVER.instantiate()
	solver.set_up(current_board)
	var _board = solver.get_solution()
	current_board = _board
	
func _on_unsolveable():
	#print ('Unsolveable, generating new one')
	new_gmae()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("regenerate"):
		new_gmae()

func check_no_board_and_level():
	while true:
		var boards := get_tree().get_nodes_in_group('boards').size()
		var levels := get_tree().get_nodes_in_group('levels').size()
		if boards == 0 and levels == 0:
			cleared.emit()
			return 
		await get_tree().create_timer(0.00001).timeout
	
