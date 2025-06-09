extends Node2D


func _on_button_pressed() -> void:
	Global.timeSpeedMultiplier = 1.0
	Global.totalMinutes = 6*60
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")
