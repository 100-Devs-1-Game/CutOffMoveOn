extends CanvasLayer


signal tool_selected(tool: ToolBase.ToolType)


func tool_button_pressed(tool: ToolBase.ToolType) -> void:
	tool_selected.emit(tool)
