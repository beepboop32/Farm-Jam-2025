extends Area2D

var hovered = false

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

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false

func _add_food_to_box():
	if Global.foodInHand > 0:
		Global.foodInHand -= 1
		print("Added food to box. Food in hand:", Global.foodInHand)

func _remove_food_from_box():
	if Global.foodInHand < 10:
		Global.foodInHand += 1
		print("Removed food from box. Food in hand:", Global.foodInHand)
