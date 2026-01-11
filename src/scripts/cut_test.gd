extends Node2D

const PIECE3_END_POS := Vector2(-340, 0)
const MIN_POINT_DIST := 48
const POINT_DIST_SQR := MIN_POINT_DIST * MIN_POINT_DIST
const cut_texture: Texture2D = preload("res://dotted_line.png")
const PIECE2_END_POS := Vector2(1536.0, 256)

@export var _guide_lines: Array[Line2D] = []


#@onready var _piece1: Sprite2D = $Piece1
@onready var _piece2: Sprite2D = $Piece2
@onready var _piece3: Sprite2D = $Piece3
@onready var _final: Sprite2D = $FinalResult
@onready var _cursor: Node2D = $Cursor


var _point_dict: Dictionary = {}
var _spawned_lines: Array[Line2D] = []

var _current_line: Line2D
var is_cutting: bool = false
var tick_delay = 10
var tick = 0

func _ready() -> void:
	_final.modulate = Color.TRANSPARENT
	for line in _guide_lines:
		for i in range(line.get_point_count()):
			var pos = Vector2i(line.get_point_position(i))
			_point_dict[pos] = false


func _process(_delta: float) -> void:
	_cursor.position = get_global_mouse_position()
	if Input.is_action_just_pressed("click"): _begin_cut()
	elif Input.is_action_just_released("click"): _end_cut()
	elif Input.is_action_pressed("click"): _continue_cut()


func _begin_cut() -> void:
	is_cutting = true
	_current_line = spawn_line()


func _end_cut() -> void:
	if not is_cutting: return
	_current_line = null
	is_cutting = false
	#TODO: Cleanup Lines, merge if possible


func _continue_cut() -> void:
	if not is_cutting: return
	tick -= 1
	if tick > 0: return
	tick = tick_delay
	var nearest: Vector2i = get_nearest_point()
	if nearest == -Vector2i.ONE: return
	_point_dict.erase(nearest)
	_current_line.add_point(nearest)
	if is_complete(): on_cut_complete()


func get_nearest_point() -> Vector2i:
	for point in _point_dict.keys():
		if get_global_mouse_position().distance_squared_to(point) < POINT_DIST_SQR:
			return point
	return -Vector2i.ONE


func is_complete() -> bool:
	return _point_dict.size() == 0


func spawn_line() -> Line2D:
	var new_line = Line2D.new()
	_spawned_lines.append(new_line)
	get_tree().current_scene.add_child(new_line)
	new_line.width = 16
	new_line.texture = cut_texture
	new_line.texture_mode = Line2D.LINE_TEXTURE_TILE
	new_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	#new_line.joint_mode = 
	return new_line


func on_cut_complete() -> void:
	create_tween().tween_property(
		_piece2, "rotation_degrees", 20, 0.7).set_ease(Tween.EASE_IN
	)
	await create_tween().tween_property(
		_piece2, "position", PIECE2_END_POS, 0.7).\
		set_ease(Tween.EASE_IN).finished
	await create_tween().tween_property(
		_piece3, "position", PIECE3_END_POS, 0.5).finished
	for line in _spawned_lines:
		create_tween().tween_property(
			line, "modulate", Color.TRANSPARENT, 0.3
		)
	await create_tween().tween_property(
		_final, "modulate", Color(10, 10, 10, 10), 0.3).finished
	await create_tween().tween_property(
		_final, "modulate", Color.WHITE, 0.3).finished
