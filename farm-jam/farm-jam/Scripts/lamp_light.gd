extends PointLight2D

@export_range(0.0, 5.0) var base_energy: float = 1.5
@export_range(0.0, 1.0) var flicker_amplitude: float = 0.1
@export_range(0.1, 5.0) var flicker_speed: float = 1.0 

@export var min_color: Color = Color(0.65, 0.75, 0.97)
@export var max_color: Color = Color(0.7, 0.8, 1.0)

var time_passed := 0.0

func _process(delta):
	time_passed += delta
	var sine = sin(time_passed * flicker_speed * TAU)
	var flicker = sine * flicker_amplitude
	energy = base_energy + flicker
	var color_factor = (sine + 1.0) / 2.0
	color = min_color.lerp(max_color, color_factor)
