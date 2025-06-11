extends Area2D
var hovered = false

func _ready() -> void:
	$"/root/Node2D/FoodBar".value = Global.foodInBox

func _input(event):
	if event is InputEventMouseButton and hovered:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if Global.foodInHand > 0:
					Global.foodInBox += 1
					Global.foodInHand -= 1
					print(Global.foodInHand)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if Global.foodInBox > 0:
					Global.foodInBox -= 1
					Global.foodInHand += 1
					print(Global.foodInHand)

func _physics_process(delta: float) -> void:
	$"/root/Node2D/FoodBar".value = Global.foodInBox


func _on_mouse_entered() -> void:
	hovered = true
func _on_mouse_exited() -> void:
	hovered = false
