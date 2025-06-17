extends Node2D
@export var fadeDuration = 0.75

func _ready() -> void:
	Global.currentDay += 1
	var color = $CanvasModulate.color
	color.a = 0.0
	$CanvasModulate.color = color
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(color.r, color.g, color.b, 1.0), fadeDuration)

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
