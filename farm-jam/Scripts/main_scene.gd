extends Node2D
@export var sheepScene: PackedScene
@export var spawnPoint: Node2D

func _on_time_button_pressed() -> void:
	Global.skipCycle()


func _on_decrease_sanity_pressed() -> void:
	Global.sanity -= 0.1

func _ready() -> void:
	if not sheepScene:
		print("No sheepScene assigned!")
		return
	if not spawnPoint:
		print("No spawnPoint assigned!")
		return
	for i in range(Global.sheepCount):
		var sheepInstance = sheepScene.instantiate()
		
		get_tree().current_scene.add_child(sheepInstance)
		
		if sheepInstance is Node2D:
			sheepInstance.position = spawnPoint.position
