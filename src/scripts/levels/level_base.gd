class_name LevelBase
extends Node2D


@onready var _cursor: Node2D = $Cursor

@export var _stages: Array[ToolBase.ToolType] = []
var current_stage: ToolBase.ToolType
var _stage_index := 0

var _tools: Array[ToolBase] = []
var current_tool: ToolBase = null
var using_tool: bool = false


func _ready() -> void:
	$GUI.tool_selected.connect(set_tool)
	current_stage = _stages[_stage_index]
	for child in get_children():
		if child is ToolBase:
			_tools.append(child)
			child.tool_complete.connect(on_tool_complete)


func _process(_delta: float) -> void:
	_cursor.position = get_global_mouse_position()
	if Input.is_action_just_pressed("LMB"): _begin_tool()
	elif Input.is_action_just_released("LMB"): _end_tool()
	elif Input.is_action_just_pressed("RMB"): set_tool(ToolBase.ToolType.NONE)
	elif Input.is_action_pressed("LMB"): _continue_tool()
	
	#TESTING
	if Input.is_action_just_pressed("TESTING"):
		print("advancing stage")
		on_tool_complete()
	#TESTING


func set_tool(new_tool: ToolBase.ToolType) -> void:
	_cursor.update_tool(new_tool)
	print("Setting Tool: %s" % ToolBase.ToolType.keys()[new_tool])
	for tool in _tools:
		if tool.tool_type == new_tool:
			current_tool = tool


func _begin_tool() -> void:
	if current_tool == null: return
	using_tool = true
	current_tool.begin_use()


func _end_tool() -> void:
	if current_tool == null or not using_tool: return
	using_tool = false
	current_tool.end_use()


func _continue_tool() -> void:
	if current_tool == null or not using_tool: return
	current_tool.continue_use()


func on_tool_complete() -> void:
	pass
