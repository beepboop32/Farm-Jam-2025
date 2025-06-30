extends Node

@export var secondsPerDay := 60.0
@export var dawnHour := 6
@export var duskHour := 20
@export var darknessStartHour := 18
@export var lightStartHour := 8
var ending = 0
var energy: float = 100.0:
	set(value):
		energy = clamp(value, 0.0, 100.0)
var trap : bool = false
var sanity : float = 1.0
var bullets: int = 6
var timeSpeedMultiplier := 0
var skippingToDusk := false
var totalMinutes: float = 6 * 60 
var currentDay: int = 1
var isDaytime: bool = true
var speedMultiplier := 1.0
var sheepCount = 4
var foodInHand = 0
var foodInBox = 100
var sheepsDead = 0
var sheep_overall_happiness = 1.0 
var money: int = 50
var timeToGlow = false
var difficulty: int = 0
var force_reproduction: int = 0
var finalDay = 10
var queueEnding = false
var home = false

@onready var modulator: CanvasModulate = get_tree().current_scene.get_node("Modulator")

func _process(delta: float) -> void:
	var minutesPerSecond = 24 * 60 / secondsPerDay
	totalMinutes += minutesPerSecond * delta * timeSpeedMultiplier
	if skippingToDusk:
		if (totalMinutes / 60.0) >= duskHour:
			speedMultiplier = 1.0
			timeSpeedMultiplier = 1
			skippingToDusk = false
			totalMinutes = duskHour * 60
	updateTimeLabel()
	updateBrightness()
	checkDayNight()
	var current_scene = get_tree().get_current_scene()
	if current_scene and current_scene.scene_file_path.ends_with("MainScene.tscn"):
		if get_living_sheep_count() == 0:
			ending = 0
			get_tree().change_scene_to_file("res://Scenes/BaseEndScene.tscn")
		elif energy <= 0:
			ending = 2
			get_tree().change_scene_to_file("res://Scenes/BaseEndScene.tscn")

func get_living_sheep_count() -> int:
	var count = 0
	for sheep in sheep_data:
		if sheep.has("health") and sheep["health"] > 0:
			count += 1
	return count

func updateTimeLabel() -> void:
	var hours = int(totalMinutes) / 60
	var minutes = int(totalMinutes) % 60
	var timeStuff
	if get_tree().get_current_scene():
		timeStuff = get_tree().get_current_scene().get_node_or_null("Time Stuff")
	if timeStuff:
		var label = timeStuff.get_node_or_null("Time Text")
		if label and label is Label:
			label.text = "%02d:%02d" % [hours, minutes]

func inRange(x: float, start: float, end: float) -> bool:
	if start <= end:
		return x >= start and x < end
	else:
		return x >= start or x < end

func updateBrightness() -> void:
	var hour = totalMinutes / 60.0
	var brightness: float
	var color: Color
	var nightBrightness = 0.4
	var dayBrightness = 1.0
	var nightColor = Color(1.0, 0.85, 0.7, 1.0)
	if inRange(hour, duskHour, dawnHour):
		brightness = nightBrightness
		color = nightColor
	elif inRange(hour, darknessStartHour, duskHour):
		var t = (hour - darknessStartHour) / (duskHour - darknessStartHour)
		brightness = lerp(dayBrightness, nightBrightness, t)
		color = Color(
			lerp(1.0, nightColor.r, t),
			lerp(1.0, nightColor.g, t),
			lerp(1.0, nightColor.b, t),
			1.0
		)
	elif inRange(hour, dawnHour, lightStartHour):
		var t = (hour - dawnHour) / (lightStartHour - dawnHour)
		brightness = lerp(nightBrightness, dayBrightness, t)
		color = Color(
			lerp(nightColor.r, 1.0, t),
			lerp(nightColor.g, 1.0, t),
			lerp(nightColor.b, 1.0, t),
			1.0
		)
	else:
		brightness = dayBrightness
		color = Color(1, 1, 1, 1)
	if get_tree().get_current_scene():
		modulator = get_tree().current_scene.get_node_or_null("Modulator")
	if modulator:
		modulator.color = Color(color.r * brightness, color.g * brightness, color.b * brightness, 1.0)

func checkDayNight() -> void:
	var hour = int(totalMinutes) / 60
	var newIsDaytime = hour >= dawnHour and hour < duskHour
	if newIsDaytime != isDaytime:
		isDaytime = newIsDaytime
		if !isDaytime:
			currentDay += 1
			difficulty += (3 * sanity)
			money += (5 + (1 - sanity))*2
			if currentDay >= finalDay:
				if sanity >= 0.5:
					ending = 1
				else:
					ending = 3
				queueEnding = true
			get_tree().change_scene_to_file("res://Scenes/HomeScene.tscn")
			timeSpeedMultiplier = 0.0

func skipCycle() -> void:
	timeSpeedMultiplier = 10.0 
	skippingToDusk = true
	speedMultiplier = 5.0
var sheep_data = []
func init_sheep_data(count: int) -> void:
	if sheep_data.size() != count:
		sheep_data.clear()
		for i in range(count):
			sheep_data.append({
				"current_hunger": 15,
				"max_hunger": randi_range(5, 25),
				"health": 25,
				"color_choice": randi_range(0, 1)
			})
