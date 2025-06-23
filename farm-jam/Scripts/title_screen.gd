extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") or event.is_action_pressed("ui_accept"):
		var tween = get_tree().create_tween()
		tween.parallel().tween_property($TitleScreen/TitleText, "modulate", Color(1, 1, 1, 0), 0.25)
		tween.parallel().tween_method(_set_shader_movement, 0.0, 1.0, 1.5)
		await tween.finished
		get_tree().change_scene_to_file("res://Scenes/TutorialScene.tscn")



func _set_shader_movement(value: float) -> void:
	var sprite: Sprite2D = $TitleScreen
	var mat: ShaderMaterial = sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("movement", value)
	else:
		push_error("TitleScreen does not have a valid ShaderMaterial!")
