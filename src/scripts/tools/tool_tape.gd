class_name TapeTool
extends ToolBase


@export var _guide_lines:  Array[Line2D] = []
var _tape_points: Array[Vector2i] = []


func _init() -> void:
	tool_type = ToolType.TAPE


func _ready() -> void:
	for line in _guide_lines:
		for i in range(line.get_point_count()):
			var pos = Vector2i(line.get_point_position(i))
			_tape_points.append(pos)


func continue_use() -> void:
	tick -= 1
	if tick > 0: return
	tick = TICK_DELAY
	
	var nearest: Vector2i = get_nearest_point(_tape_points)
	if nearest == -Vector2i.ONE: return
	_tape_points.remove_at(_tape_points.find(nearest))
	if _tape_points.size() == 0: _on_tape_complete()


func get_nearest_point(arr: Array[Vector2i]) -> Vector2i:
	for point in arr:
		if get_global_mouse_position().distance_squared_to(point) < POINT_DIST_SQR:
			return point
	return -Vector2i.ONE


func _on_tape_complete() -> void:
	tool_complete.emit()
