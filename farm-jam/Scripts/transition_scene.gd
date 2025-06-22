extends Node2D

@onready var dead_label = $Background/Dead
@onready var reproduced_label = $Background/Reproduced
@onready var happiness_label = $Background/Happiness
@onready var continue_button = $Background/Continue

func _ready():
	var died = 0
	var born = 0
	var happiness = 0.0
	for i in Global.sheep_data:
		if i.current_hunger <= 0 or i.health <= 0:
			died += 1
	print(Global.sheep_data)
	dead_label.text = "💀 Sheep that died during the night: %d" % died
	reproduced_label.text = "🐣 Sheep that reproduced: %d" % born
	happiness_label.text = "😊 Overall sheep happiness: %d%%" % int(happiness * 100)

	continue_button.pressed.connect(_on_continue_pressed)

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")
