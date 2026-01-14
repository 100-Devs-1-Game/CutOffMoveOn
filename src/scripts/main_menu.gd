extends Control



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_01.tscn")


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_full_screen_pressed() -> void:
	pass
