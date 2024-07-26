extends Node2D
class_name Cell

@onready var color_rect: ColorRect = %ColorRect
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var button: Button = %Button
@onready var debug_label: Label = %DebugLabel

const CROWN_IMAGE := preload("res://assets/images/crown_image.png")
const STRIPES_IMAGE := preload("res://assets/images/stripes_image.png")
const X_IMAGE := preload("res://assets/images/x_image.png")

var row : int
var col : int
var is_queen := false 
var can_queen := true
var current_state := 'empty'
var color_name : String
var color_code := Color.DARK_SLATE_GRAY
var is_occupied := false

var state_images := {
	'empty': null, 
	'x': X_IMAGE,
	'crown': CROWN_IMAGE,
	'stripes' : STRIPES_IMAGE
}

func _ready() -> void:
	button.pressed.connect(change_to_next_state_button)
	sprite_2d.texture = state_images[current_state]
	debug_label.visible = false

func reset_state():
	current_state = 'stripes'
	change_to_next_state()

func change_to_next_state_button():
	match current_state:
		'empty':
			current_state = 'x'
			sprite_2d.texture = state_images[current_state]
		'x':
			current_state = 'crown'
			sprite_2d.texture = state_images[current_state]
		'crown':
			current_state = 'empty'
			sprite_2d.texture = state_images[current_state]
		'stripes':
			current_state = 'empty'
			sprite_2d.texture = state_images[current_state]

func change_to_next_state():
	match current_state:
		'empty':
			current_state = 'x'
			sprite_2d.texture = state_images[current_state]
		'x':
			current_state = 'crown'
			sprite_2d.texture = state_images[current_state]
		'crown':
			current_state = 'stripes'
			sprite_2d.texture = state_images[current_state]
		'stripes':
			current_state = 'empty'
			sprite_2d.texture = state_images[current_state]

func set_row_col(_row : int, _col : int):
	row = _row
	col = _col


func set_debug_label(_text : String):
	if debug_label.text:
		debug_label.text = debug_label.text + ' ' + _text
	else:
		debug_label.text = _text 
		
func show_debug_label():
	debug_label.visible  = !debug_label.visible

func selected_as_querens(color:Dictionary):
	if !is_queen:
		is_queen = true
		set_debug_label('Q')
		assign_color(color)
	
func mark_as_cant_queens():
	if can_queen and !is_queen:
		can_queen = false
		#set_debug_label('X')
		
func assign_color(_color:Dictionary):
	color_name = _color['color_name']
	color_code = _color['color_code']
	color_rect.color = color_code
	add_to_group(_color['color_name'])
	#set_debug_label(_color['color_namsse'].left(2))
	
func set_occupied():
	is_occupied = true
	
	
func _to_string() -> String:
	return '(%d, %d, %s, %s)' % [row, col, is_queen, color_name]

func reset():
	is_queen = false 
	can_queen = true
	color_rect.color = Color.WHITE
