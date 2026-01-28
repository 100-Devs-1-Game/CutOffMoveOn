extends LevelBase


const PIECE3_END_POS := Vector2(-338 * 0.8 + 160.0, 0)
const PIECE2_END_POS := Vector2(1536.0, 256)


#@onready var _piece1: Sprite2D = $Piece1
@onready var _piece2: Sprite2D = $Piece2
@onready var _piece3: Sprite2D = $Piece3
@onready var _final: Sprite2D = $FinalResult


func _ready() -> void:
	super._ready()
	_final.modulate = Color.TRANSPARENT


func on_tool_complete() -> void:
	match current_stage:
		ToolBase.ToolType.SCISSORS:
			on_cut_complete()
		ToolBase.ToolType.TAPE:
			on_level_complete()


func on_cut_complete() -> void:
	create_tween().tween_property(
		_piece2, "rotation_degrees", 20, 0.7).set_ease(Tween.EASE_IN
	)
	await create_tween().tween_property(
		_piece2, "position", PIECE2_END_POS, 0.7).\
		set_ease(Tween.EASE_IN).finished
	await create_tween().tween_property(
		_piece3, "position", PIECE3_END_POS, 0.5).finished
	_stage_index += 1
	current_stage = _stages[_stage_index]
	set_tool(ToolBase.ToolType.NONE)
	$TapeStrip.visible = true


func on_level_complete() -> void:
	$TapeStrip.visible = false
	await create_tween().tween_property(
		_final, "modulate", Color(10, 10, 10, 10), 0.3).finished
	await create_tween().tween_property(
		_final, "modulate", Color.WHITE, 0.3).finished
