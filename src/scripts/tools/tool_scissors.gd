class_name ScissorsTool
extends ToolBase

const cut_texture: Texture2D = preload("res://gfx/ui/dotted_line.png")


@export var _guide_lines: Array[Line2D] = []

var _cut_points: Array[Vector2i] = []
var _spawned_lines: Array[Line2D] = []
var _current_line: Line2D


func _init() -> void:
	tool_type = ToolType.SCISSORS


func _ready() -> void:
	for line in _guide_lines:
		for i in range(line.get_point_count()):
			var pos = Vector2i(line.get_point_position(i))
			_cut_points.append(pos)


func begin_use() -> void:
	_current_line = spawn_line()


func end_use() -> void:
	_current_line = null
	#TODO: Cleanup Lines, merge if possible, check for empty


func continue_use() -> void:
	tick -= 1
	if tick > 0: return
	tick = TICK_DELAY
	var nearest: Vector2i = get_nearest_point(_cut_points)
	if nearest == -Vector2i.ONE: return
	_cut_points.remove_at(_cut_points.find(nearest))
	_current_line.add_point(nearest)
	# There is occassionally(?) a stray point that is missed
	if _cut_points.size() <= 1: _on_cut_complete()


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


func _on_cut_complete() -> void:
	for line in _spawned_lines:
		create_tween().tween_property(
			line, "modulate", Color.TRANSPARENT, 0.3
		)
	tool_complete.emit()
