extends Node2D

@export var sheepScene: PackedScene
@export var skeletonScene: PackedScene
@export var ghostScene: PackedScene
@export var spawnPoint: Node2D
@onready var day_label = $"Stats Panel/Day Counter"
var deaths = 0

func _on_time_button_pressed() -> void:
	Global.skipCycle()

func _on_decrease_sanity_pressed() -> void:
	Global.sanity -= 0.1

func _ready() -> void:
	set_process_input(true)
	DisplayDay()
	deaths = 0
	var births = 0 

	if not sheepScene:
		print("No sheepScene assigned!")
		return
	
	if not skeletonScene:
		print("No skeletonScene assigned!")
		return

	if not spawnPoint:
		print("No spawnPoint assigned!")
		return
	
	Global.init_sheep_data(Global.sheepCount)

	var healthy_sheep_indices := []
	for i in range(Global.sheepCount):
		var hunger = Global.sheep_data[i]["current_hunger"]
		var max_hunger = Global.sheep_data[i]["max_hunger"]
		if max_hunger > 0 and hunger > max_hunger / 2:
			healthy_sheep_indices.append(i)
	
	var pairs = healthy_sheep_indices.size() / 2
	for i in range(int(pairs)):
		if randf() < 0.5:
			var new_sheep = {
				"current_hunger": randi_range(3, 10),
				"max_hunger": randi_range(5, 25),
				"health": 100,
				"color_choice": randi_range(0, 1)
			}
			Global.sheep_data.append(new_sheep)
			Global.sheepCount += 1
			births += 1

	var sheep_positions := []

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
				deaths += 1
				sheep_positions.append(sheepInstance.position)
				sheepInstance.queue_free()
	for pos in sheep_positions:
		# Spawn skeleton
		var skeletonInstance = skeletonScene.instantiate()
		get_tree().current_scene.add_child(skeletonInstance)
		if skeletonInstance is Node2D:
			skeletonInstance.position = pos

		# Spawn ghost
		print("Spawning ghost!")
		var ghostInstance = ghostScene.instantiate()
		get_tree().current_scene.add_child(ghostInstance)
		if ghostInstance is Node2D:
			ghostInstance.position = pos
			# Animate: fly up and fade out
			var tween = get_tree().create_tween()
			tween.tween_property(ghostInstance, "position:y", pos.y - 100, 1.5)
			tween.tween_property(ghostInstance, "modulate:a", 0.0, 1.5)
			tween.tween_property(ghostInstance, "position:y", pos.y - 100, 1.5)
			tween.tween_property(ghostInstance, "modulate:a", 0.0, 1.5)
			tween.finished.connect(func(): ghostInstance.queue_free())
	$"Stats Panel/DeathLabel".text = "%d Sheep Died" % [deaths]
	$"Stats Panel/BirthLabel".text = "%d Sheep Born" % [births]

var skip_requested := false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		skip_requested = true

func wait_with_skip(duration: float) -> void:
	var timer := 0.0
	while timer < duration:
		if skip_requested:
			return
		await get_tree().process_frame
		timer += get_process_delta_time()

func DisplayDay() -> void:
	skip_requested = false
	var core_text: String = "Day %s" % [Global.currentDay]
	var typed: String = ""
	day_label.text = "----"
	$"Stats Panel".modulate.a = 0.0
	day_label.visible = true

	var tween := get_tree().create_tween()
	tween.tween_property($"Stats Panel", "modulate:a", 1.0, 0.5)
	await tween.finished
	if skip_requested:
		await _skip_to_stats_panel()
		return

	await wait_with_skip(1.0)
	if skip_requested:
		await _skip_to_stats_panel()
		return

	for i in core_text.length():
		typed += core_text[i]
		day_label.text = "--%s--" % typed
		await wait_with_skip(0.3)
		if skip_requested:
			await _skip_to_stats_panel()
			return

	await wait_with_skip(2.0)
	if skip_requested:
		await _skip_to_stats_panel()
		return

	for i in range(core_text.length(), 0, -1):
		typed = typed.substr(0, i - 1)
		day_label.text = "--%s--" % typed
		await wait_with_skip(0.3)
		if skip_requested:
			await _skip_to_stats_panel()
			return

	day_label.text = "----"
	await wait_with_skip(0.5)
	if skip_requested:
		await _skip_to_stats_panel()
		return

	await _skip_to_stats_panel()

func _skip_to_stats_panel() -> void:
	day_label.text = "----"
	skip_requested = false
	$"Stats Panel".visible = true
	var tween := get_tree().create_tween()
	tween.tween_property($"Stats Panel", "modulate:a", 0.0, 0.5)
	await tween.finished
	$"Stats Panel".visible = false

func _physics_process(delta: float) -> void:
	$"Energy Label".text = "⚡Energy: %d%%" % [round(Global.energy)]
