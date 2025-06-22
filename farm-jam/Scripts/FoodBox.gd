extends Area2D

var hovered = false

func _ready() -> void:
	$"/root/Node2D/FoodBar".value = Global.foodInBox
	# Connect to all skeletons currently in the scene
	for skeleton in get_tree().get_nodes_in_group("skeletons"):
		_connect_skeleton(skeleton)
	# Listen for new nodes added to the scene tree
	get_tree().connect("node_added", Callable(self, "_on_node_added"))

func _on_node_added(node):
	if node.is_in_group("skeletons"):
		_connect_skeleton(node)

func _connect_skeleton(skeleton):
	if not skeleton.is_connected("dropped", Callable(self, "_on_skeleton_dropped")):
		skeleton.connect("dropped", Callable(self, "_on_skeleton_dropped").bind(skeleton))

func _on_skeleton_dropped(skeleton):
	print("Received dropped signal from skeleton")
	if self.get_global_rect().intersects(skeleton.get_global_rect()):
		Global.foodInBox += 35
		skeleton.queue_free()

func get_global_rect() -> Rect2:
	var shape = $CollisionShape2D.shape
	var pos = global_position
	if shape is RectangleShape2D:
		var size = shape.extents * 2
		return Rect2(pos - size / 2, size)
	return Rect2(pos, Vector2(32, 32)) # fallback

func _input(event):
	if event is InputEventMouseButton and hovered:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_add_food_to_box()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_remove_food_from_box()
	if event is InputEventKey and event.is_pressed() and hovered:
		if event.keycode == KEY_UP:
			_add_food_to_box()
		elif event.keycode == KEY_DOWN:
			_remove_food_from_box()



func _physics_process(delta: float) -> void:
	$"/root/Node2D/FoodBar".value = Global.foodInBox

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false

func _add_food_to_box():
	if Global.foodInHand > 0:
		Global.foodInBox += 1
		Global.foodInHand -= 1
		Global.energy -= 0.5
		print("Added food to box. Food in hand:", Global.foodInHand)

func _remove_food_from_box():
	if Global.foodInBox > 0 and Global.foodInHand < 10:
		Global.foodInBox -= 1
		Global.foodInHand += 1
		Global.energy -= 0.5
		print("Removed food from box. Food in hand:", Global.foodInHand)
