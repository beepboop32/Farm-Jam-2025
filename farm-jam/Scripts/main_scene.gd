extends Node2D

@export var sheepScene: PackedScene
@export var skeletonScene: PackedScene
@export var ghostScene: PackedScene
@export var spawnPoint: Node2D
@onready var day_label = $"Stats Panel/Day Counter"
var deaths = 0
var skip_requested = false

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
	var forced_birth_done = false
	for i in range(int(pairs)):
		var base_repro_chance = 0.5
		var repro_chance = min(base_repro_chance + Global.difficulty * 0.03, 0.95)
		var do_birth = randf() < repro_chance
		if Global.force_reproduction > 0 and not forced_birth_done:
			do_birth = true
			forced_birth_done = true
			Global.force_reproduction -= 1
		if do_birth:
			var new_sheep = {
				"current_hunger": randi_range(5, 15),
				"max_hunger": randi_range(5, 25),
				"health": 100,
				"color_choice": randi_range(0, 1)
			}
			if new_sheep["current_hunger"] > new_sheep["max_hunger"]:
				new_sheep["current_hunger"] = new_sheep["max_hunger"]
			Global.sheep_data.append(new_sheep)
			Global.sheepCount += 1
			births += 1

	var sheep_positions := []
	for i in range(Global.sheepCount - 1, -1, -1):
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
				print(Global.sheep_data[i])
				deaths += 1
				Global.sheepCount -= 1
				Global.sheep_data.remove_at(i)
				sheep_positions.append(sheepInstance.position)
				sheepInstance.queue_free()
	$"Stats Panel/DeathLabel".text = "%d Sheep Died" % [deaths]
	$"Stats Panel/BirthLabel".text = "%d Sheep Born" % [births]

	var sheep_stolen = 0
	if not Global.trap:
		var base_steal_chance = 0.25
		var steal_chance = min(base_steal_chance + Global.difficulty * 0.05, 0.9)
		var max_to_steal = int(Global.sheepCount / 2)
		var sheep_indices = []
		for i in range(Global.sheepCount):
			sheep_indices.append(i)
		while sheep_stolen < max_to_steal and sheep_indices.size() > 0:
			if randf() < steal_chance:
				var idx = randi_range(0, sheep_indices.size() - 1)
				var remove_id = sheep_indices[idx]
				Global.sheep_data.remove_at(remove_id)
				Global.sheepCount -= 1
				sheep_indices.remove_at(idx)
				for j in range(sheep_indices.size()):
					if sheep_indices[j] > remove_id:
						sheep_indices[j] -= 1
				sheep_stolen += 1
			else:
				break
	$"Stats Panel/StolenLabel".text = "%d Sheep Stolen" % [sheep_stolen]

	for i in range(Global.sheep_data.size()):
		Global.sheep_data[i]["current_hunger"] = max(0, Global.sheep_data[i]["current_hunger"] - (1 + Global.difficulty * 0.2))

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

	await wait_with_skip(0.5)
	if skip_requested:
		await _skip_to_stats_panel()
		return

	for i in core_text.length():
		typed += core_text[i]
		day_label.text = "--%s--" % typed
		await wait_with_skip(0.15)
		if skip_requested:
			await _skip_to_stats_panel()
			return

	await wait_with_skip(1.0)
	if skip_requested:
		await _skip_to_stats_panel()
		return

	for i in range(core_text.length(), 0, -1):
		typed = typed.substr(0, i - 1)
		day_label.text = "--%s--" % typed
		await wait_with_skip(0.15)
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

func _process(_delta: float) -> void:
	$"Energy Label".text = "⚡Energy: %d%%" % [round(Global.energy)]
	# Outline glow for Donate Box and Self Box
	var outline_color = Color(1,1,1,1) if Global.timeToGlow else Color(1,1,1,0)
	if has_node("DonateBox"):
		var donate_box = get_node("DonateBox")
		if donate_box.has_node("Sprite2D"):
			donate_box.get_node("Sprite2D").material.set_shader_parameter("outline_color", outline_color)
	if has_node("SelfBox"):
		var self_box = get_node("SelfBox")
		if self_box.has_node("Sprite2D"):
			self_box.get_node("Sprite2D").material.set_shader_parameter("outline_color", outline_color)
