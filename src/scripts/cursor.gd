extends Node2D


const sprite_dict: Dictionary = {
	ToolBase.ToolType.SCISSORS: preload("res://gfx/tools/scissors2.png"),
	ToolBase.ToolType.TAPE: preload("res://gfx/tools/tape.png"),
	ToolBase.ToolType.MARKER: preload("res://gfx/tools/marker.png"),
	ToolBase.ToolType.LIGHTER: preload("res://gfx/tools/lighter.png"),
}

const rot_dict: Dictionary = {
	ToolBase.ToolType.SCISSORS: 135,
	ToolBase.ToolType.TAPE: 0,
	ToolBase.ToolType.MARKER: 0,
	ToolBase.ToolType.LIGHTER: 0,
}


func _process(_delta: float) -> void:
	position = get_global_mouse_position()


func update_tool(tool: ToolBase.ToolType) -> void:
	$Sprite2D.texture = sprite_dict.get(tool, null)
	$Sprite2D.rotation_degrees = rot_dict.get(tool, 0)
