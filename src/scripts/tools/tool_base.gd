class_name ToolBase
extends Node2D


const TICK_DELAY := 10
const MIN_POINT_DIST := 48
const POINT_DIST_SQR := MIN_POINT_DIST * MIN_POINT_DIST

@warning_ignore("unused_signal")
signal tool_complete()

enum ToolType {
	NONE,
	SCISSORS,
	TAPE,
	MARKER,
	STICKERS,
	LIGHTER,
}

var tool_type: ToolType = ToolType.NONE
var tick := 0


func begin_use() -> void:
	pass


func continue_use() -> void:
	pass


func end_use() -> void:
	pass
