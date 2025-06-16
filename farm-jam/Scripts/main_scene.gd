extends Node2D
@export var sheepScene: PackedScene
@export var spawnPoint: Node2D
@onready var day_label = $"Day Counter"

func _on_time_button_pressed() -> void:
	Global.skipCycle()

func _on_decrease_sanity_pressed() -> void:
	Global.sanity -= 0.1

func _ready() -> void:
	DisplayDay()
	if not sheepScene:
		print("No sheepScene assigned!")
		return
	if not spawnPoint:
		print("No spawnPoint assigned!")
		return
	Global.init_sheep_data(Global.sheepCount)
	for i in range(Global.sheepCount):
		var sheepInstance = sheepScene.instantiate()
		get_tree().current_scene.add_child(sheepInstance)
		if sheepInstance is Node2D:
			sheepInstance.position = spawnPoint.position
			sheepInstance.sheep_id = i
			sheepInstance.set_hunger_health(
				Global.sheep_data[i]["current_hunger"],
				Global.sheep_data[i]["max_hunger"],
				Global.sheep_data[i]["health"]
			)
			sheepInstance.set_color_choice(Global.sheep_data[i]["color_choice"])
			if sheepInstance.apply_hunger_decay_on_load():
				sheepInstance.queue_free()

func DisplayDay() -> void:
	var core_text: String = "Day %s" % [Global.currentDay]
	var typed: String = ""
	day_label.text = "----"
	day_label.modulate.a = 0.0
	day_label.visible = true

	var tween := get_tree().create_tween()
	tween.tween_property(day_label, "modulate:a", 1.0, 0.5)
	await tween.finished

	await get_tree().create_timer(1).timeout
	for i in core_text.length():
		typed += core_text[i]
		day_label.text = "--%s--" % typed
		await get_tree().create_timer(0.3).timeout
	await get_tree().create_timer(2.0).timeout
	for i in range(core_text.length(), 0, -1):
		typed = typed.substr(0, i - 1)
		day_label.text = "--%s--" % typed
		await get_tree().create_timer(0.3).timeout

	day_label.text = "----"
	await get_tree().create_timer(0.5).timeout
	tween = get_tree().create_tween()
	tween.tween_property(day_label, "modulate:a", 0.0, 0.5)
	await tween.finished

	day_label.visible = false
