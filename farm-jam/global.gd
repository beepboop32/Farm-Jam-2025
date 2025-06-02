extends Node

@export var secondsPerDay := 60.0
@export var dawnHour := 6
@export var duskHour := 20

var totalMinutes: float = 6 * 60 
var currentDay: int = 1
var isDaytime: bool = true

@onready var modulator: CanvasModulate = get_tree().current_scene.get_node("Modulator")

func _process(delta: float) -> void:
	var minutesPerSecond = 24 * 60 / secondsPerDay
	totalMinutes += minutesPerSecond * delta
	if totalMinutes >= 1440:
		totalMinutes -= 1440
		currentDay += 1
	updateTimeLabel()
	updateBrightness()
	checkDayNight()

func updateTimeLabel() -> void:
	var hours = int(totalMinutes) / 60
	var minutes = int(totalMinutes) % 60
	var label = get_tree().get_current_scene().get_node_or_null("Time Text")
	if label and label is Label:
		label.text = "%02d:%02d" % [hours, minutes]

func updateBrightness() -> void:
	var hour = totalMinutes / 60.0
	var brightness = 0.4

	if hour >= dawnHour and hour <= duskHour:
		brightness = 1.0
	elif hour < dawnHour:
		brightness = lerp(0.4, 1.0, (hour + (24 - duskHour)) / (dawnHour + (24 - duskHour)))
	elif hour > duskHour:
		brightness = lerp(1.0, 0.4, (hour - duskHour) / (24 - duskHour + dawnHour))

	if modulator:
		modulator.color = Color(brightness, brightness, brightness, 1.0)

func checkDayNight() -> void:
	var hour = int(totalMinutes) / 60
	var newIsDaytime = hour >= dawnHour and hour < duskHour
	if newIsDaytime != isDaytime:
		isDaytime = newIsDaytime
		if isDaytime:
			print("Day started: Day", currentDay)
		else:
			print("Night started: Day", currentDay)
