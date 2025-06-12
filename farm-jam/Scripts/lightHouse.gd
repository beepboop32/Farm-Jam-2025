extends PointLight2D

@export_range(0.0, 5.0) var base_energy: float = 1.5
@export_range(0.0, 0.2) var flicker_strength: float = 0.05
@export_range(0.2, 1.0) var flicker_interval: float = 0.5

@export var base_color: Color = Color(0.435, 1.0, 1.0)
@export var color_variation: float = 0.015 

var time_passed := 0.0

func _process(delta):
	time_passed += delta
	if time_passed >= flicker_interval:
		time_passed = 0.0
		var flicker = randf_range(-flicker_strength, flicker_strength)
		energy = clamp(base_energy + flicker, 0.0, base_energy + flicker_strength)
		var r = clamp(base_color.r + randf_range(-color_variation, color_variation), 0.0, 1.0)
		var g = clamp(base_color.g + randf_range(-color_variation, color_variation), 0.0, 1.0)
		var b = clamp(base_color.b + randf_range(-color_variation, color_variation), 0.0, 1.0)
		color = Color(r, g, b)
