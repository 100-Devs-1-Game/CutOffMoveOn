extends Node2D

const CUT_STAGE := 0
const TAPE_STAGE := 1

const PIECE3_END_POS := Vector2(-338, 0)
const MIN_POINT_DIST := 48
const POINT_DIST_SQR := MIN_POINT_DIST * MIN_POINT_DIST
const cut_texture: Texture2D = preload("res://gfx/dotted_line.png")
const PIECE2_END_POS := Vector2(1536.0, 256)

@export var _guide_lines: Array[Line2D] = []
@onready var _tape_guide: Line2D = $TapeLine

#@onready var _piece1: Sprite2D = $Piece1
@onready var _piece2: Sprite2D = $Piece2
@onready var _piece3: Sprite2D = $Piece3
@onready var _final: Sprite2D = $FinalResult
@onready var _cursor: Node2D = $Cursor


var _cut_points: Array[Vector2i] = []
var _tape_points: Array[Vector2i] = []
var _spawned_lines: Array[Line2D] = []

var current_stage := CUT_STAGE
var _current_line: Line2D
var using_tool: bool = false
var tick_delay = 10
var tick = 0


func _ready() -> void:
	_final.modulate = Color.TRANSPARENT
	for line in _guide_lines:
		for i in range(line.get_point_count()):
			var pos = Vector2i(line.get_point_position(i))
			_cut_points.append(pos)
	for i in range(_tape_guide.get_point_count()):
		var pos = Vector2i(_tape_guide.get_point_position(i))
		_tape_points.append(pos)


func _process(_delta: float) -> void:
	_cursor.position = get_global_mouse_position()
	if Input.is_action_just_pressed("click"): _begin_tool()
	elif Input.is_action_just_released("click"): _end_tool()
	elif Input.is_action_pressed("click"): _continue_tool()


func _begin_tool() -> void:
	using_tool = true
	if current_stage == CUT_STAGE:
		_current_line = spawn_line()


func _end_tool() -> void:
	if not using_tool: return
	using_tool = false
	if current_stage == CUT_STAGE:
		_current_line = null
	#TODO: Cleanup Lines, merge if possible, check for empty


func _continue_tool() -> void:
	if not using_tool: return
	if current_stage == CUT_STAGE: _handle_cutting()
	else: _handle_taping()


func _handle_cutting() -> void:
	tick -= 1
	if tick > 0: return
	tick = tick_delay
	var nearest: Vector2i = get_nearest_point(_cut_points)
	if nearest == -Vector2i.ONE: return
	_cut_points.remove_at(_cut_points.find(nearest))
	_current_line.add_point(nearest)
	# There is occassionally(?) a stray point that is missed
	if _cut_points.size() <= 1: on_cut_complete()


func _handle_taping() -> void:
	tick -= 1
	if tick > 0: return
	tick = tick_delay
	var nearest: Vector2i = get_nearest_point(_tape_points)
	if nearest == -Vector2i.ONE: return
	_tape_points.remove_at(_tape_points.find(nearest))
	if _tape_points.size() == 0: on_level_complete()


func get_nearest_point(arr: Array[Vector2i]) -> Vector2i:
	for point in arr:
		if get_global_mouse_position().distance_squared_to(point) < POINT_DIST_SQR:
			return point
	return -Vector2i.ONE


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
	current_stage = TAPE_STAGE
	$Cursor/Sprite2D.texture = load("res://gfx/tape.png")
	$Cursor/Sprite2D.rotation = 0
	$TapeStrip.visible = true



func on_level_complete() -> void:
	$TapeStrip.visible = false
	await create_tween().tween_property(
		_final, "modulate", Color(10, 10, 10, 10), 0.3).finished
	await create_tween().tween_property(
		_final, "modulate", Color.WHITE, 0.3).finished
