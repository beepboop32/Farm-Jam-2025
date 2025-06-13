extends CanvasLayer

@export var wheat_texture: Texture2D
@export var pointer_texture: Texture2D
var max_food_hand := 10

var cursor_sprite := Sprite2D.new()
var wheat_container := Node2D.new()

func _ready():
	add_child(wheat_container)
	add_child(cursor_sprite)
	cursor_sprite.z_index = 1000
	wheat_container.z_index = 1000
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.foodInHand = 0

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	cursor_sprite.global_position = mouse_pos
	wheat_container.global_position = mouse_pos

	# Clamp foodInHand so it never goes below zero
	Global.foodInHand = max(Global.foodInHand, 0)

	if Global.foodInHand > 0:
		cursor_sprite.visible = false
		_update_wheat_sprites()
	else:
		cursor_sprite.visible = true
		cursor_sprite.texture = pointer_texture
		cursor_sprite.scale = Vector2.ONE * 2.0
		_clear_wheat_sprites()

var wheat_rotations := []

func _update_wheat_sprites():
	var count = clamp(Global.foodInHand, 0, max_food_hand)
	var current_count = wheat_container.get_child_count()

	# Add new sprites and generate random rotations for them
	if count > current_count:
		for i in range(count - current_count):
			var s = Sprite2D.new()
			s.texture = wheat_texture
			wheat_container.add_child(s)
			# Generate a random rotation once and store it
			wheat_rotations.append(randf_range(-0.785, 0.785))  # ~±45 degrees
	elif count < current_count:
		# Remove sprites and remove their rotations
		for i in range(current_count - 1, count - 1, -1):
			var s = wheat_container.get_child(i)
			if s:
				s.queue_free()
				wheat_rotations.remove_at(i)

	# Position and apply the stored rotation to each wheat sprite
	for i in range(count):
		var s = wheat_container.get_child(i)
		if s:
			s.position = Vector2(0, -i * 1.5)  # smaller vertical step (1.5 pixels)
			s.rotation = wheat_rotations[i]
			s.scale = Vector2.ONE * 2




func _clear_wheat_sprites():
	for i in range(wheat_container.get_child_count() - 1, -1, -1):
		var s = wheat_container.get_child(i)
		if s:
			s.queue_free()
