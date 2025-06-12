extends Node2D


func _on_button_pressed() -> void:
	Global.timeSpeedMultiplier = 1.0
	Global.totalMinutes = 6*60
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")


func _on_lamp_switch_pressed() -> void:
	$"Lamp Light".visible = !$"Lamp Light".visible
	if $"Lamp Light".visible:
		$CanvasModulate.color = Color(0.325, 0.325, 0.325)
	else:
		$CanvasModulate.color = Color(0.144, 0.144, 0.144)
