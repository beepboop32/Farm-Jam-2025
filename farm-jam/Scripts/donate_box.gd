extends Area2D


func _ready() -> void:
	$"/root/Node2D/FoodBar".value = Global.foodInBox
	for skeleton in get_tree().get_nodes_in_group("skeletons"):
		_connect_skeleton(skeleton)
	get_tree().connect("node_added", Callable(self, "_on_node_added"))

func _on_node_added(node):
	if node.is_in_group("skeletons"):
		_connect_skeleton(node)

func _connect_skeleton(skeleton):
	if not skeleton.is_connected("dropped", Callable(self, "_on_skeleton_dropped")):
		skeleton.connect("dropped", Callable(self, "_on_skeleton_dropped").bind(skeleton))

func _on_skeleton_dropped(skeleton):
	print("Received dropped signal from skeleton (donate)")
	if self.get_global_rect().intersects(skeleton.get_global_rect()):
		print("Skeleton dropped in donate box")
		Global.money += 10
		skeleton.queue_free()

func get_global_rect() -> Rect2:
	var shape = $CollisionShape2D.shape
	var pos = global_position
	if shape is RectangleShape2D:
		var size = shape.extents * 2
		return Rect2(pos - size / 2, size)
	return Rect2(pos, Vector2(32, 32))