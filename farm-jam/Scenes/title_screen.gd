extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") or event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/TutorialScene.tscn")
