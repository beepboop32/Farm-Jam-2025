extends Node

@export var secondsPerDay := 60.0
@export var dawnHour := 6
@export var duskHour := 20
@export var darknessStartHour := 18
@export var lightStartHour := 8
var sanity : float = 1.0
var timeSpeedMultiplier := 1.0
var skippingToDusk := false
var totalMinutes: float = 6 * 60 
var currentDay: int = 1
var isDaytime: bool = true
var speedMultiplier := 1.0
var sheepCount = 2
var foodInHand = 0
var foodInBox = 100

@onready var modulator: CanvasModulate = get_tree().current_scene.get_node("Modulator")

func _process(delta: float) -> void:
	var minutesPerSecond = 24 * 60 / secondsPerDay
	totalMinutes += minutesPerSecond * delta * timeSpeedMultiplier
	if totalMinutes >= 1440:
		totalMinutes -= 1440
		currentDay += 1
	if skippingToDusk:
		if (totalMinutes / 60.0) >= duskHour:
			speedMultiplier = 1.0
			timeSpeedMultiplier = 1.0
			skippingToDusk = false
			totalMinutes = duskHour * 60
	updateTimeLabel()
	updateBrightness()
	checkDayNight()

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
				"current_hunger": 5,
				"max_hunger": randi_range(5, 25),
				"health": 25,
				"color_choice": randi_range(0, 1)
			})
