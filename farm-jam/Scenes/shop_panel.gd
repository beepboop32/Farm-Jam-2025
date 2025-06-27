extends Panel

func buyProduct(price):
	if Global.money >= price:
		Global.money -= price
		return true
	else:
		return false

func _on_food_c_pressed() -> void:
	if !buyProduct(2):
		return
	Global.foodInBox += 10
	Global.sanity -= 0.1

func _on_food_b_pressed() -> void:
	if !buyProduct(5):
		return
	Global.foodInBox += 10
	Global.sanity -= 0.05 

func _on_food_a_pressed() -> void:
	if !buyProduct(10):
		return
	Global.foodInBox += 10
	Global.sanity += 0.05


func _on_method_a_pressed() -> void:
	if !buyProduct(2):
		return
	Global.bullets += 1


func _on_method_b_pressed() -> void:
	if !buyProduct(5):
		return
	Global.trap = true


func _on_method_c_pressed() -> void:
	if !buyProduct(10):
		return
	Global.force_reproduction += 1
