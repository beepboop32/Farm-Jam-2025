extends Node2D


func _on_time_button_pressed() -> void:
	Global.skipCycle()


func _on_decrease_sanity_pressed() -> void:
	Global.sanity -= 0.1
