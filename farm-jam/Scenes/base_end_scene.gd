extends Node2D
@export var Endings: Array[Texture2D]
@export var Texts: Array[String]

func _ready():
	Global.timeSpeedMultiplier = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.5)
	var sprite: Sprite2D = $DialogueBox/Sprite2D
	var material: ShaderMaterial = sprite.material as ShaderMaterial
	var color: Color = material.get_shader_parameter("circle_color")

	color.a = 0.0
	material.set_shader_parameter("circle_color", color)

	tween.tween_method(
		func(new_alpha: float) -> void:
			var updated_color: Color = material.get_shader_parameter("circle_color")
			updated_color.a = new_alpha
			material.set_shader_parameter("circle_color", updated_color),
		0.0, 0.5, 1.0
	)

	$ScenePicture.texture = Endings[Global.ending]
	$DialogueBox/Label.text = Texts[Global.ending]
