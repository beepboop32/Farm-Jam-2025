extends Button

@export var sheepScene: PackedScene
@export var spawnPoint: Node2D

func _pressed() -> void:
	if not sheepScene:
		print("No sheepScene assigned!")
		return
	if not spawnPoint:
		print("No spawnPoint assigned!")
		return
	
	var sheepInstance = sheepScene.instantiate()
	
	get_tree().current_scene.add_child(sheepInstance)
	
	if sheepInstance is Node2D:
		sheepInstance.position = spawnPoint.position
