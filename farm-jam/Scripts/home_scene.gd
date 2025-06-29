extends Node2D
@export var fadeDuration = 0.75

var dayNewsReports = [
	"We're fucked, fucked, fucked, so fucking fucked!",
	"Nothing but boring",
	"Baby eats other Baby?????",
	"THROW THE CHEEEEEESEEEE!!!1!!",
	"Crab Dinosaurs vs Giant Cactus Fleas!!!?!",
	"Remeber to go up the road instead of crossing the streat!",
	"I gently open the door...",
	"CAFFIENE!!!!!!!!!!!!!!!!!!!!!!!!!",
	"Meow mraw mow mow meow RAWR prrrr... mrrrp! Mowwwrrr mewmew meow, hissss—thump! Prrrt! Mrawr meowww chirrup mow mow. RAWRRR! skritch skritch Purrrrr... meow? Meow. Meow meow! YAWN Prrrrr... 🐾"
]

func _process(delta: float) -> void:
	if !DialogBox.exists:
		$ButtonLayer.visible = true

func _ready() -> void:
	Global.currentDay += 1
	var color = $CanvasModulate.color
	color.a = 0.0
	$CanvasModulate.color = color
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(color.r, color.g, color.b, 1.0), fadeDuration)
	if Global.currentDay <= len(dayNewsReports):
		DialogBox.show_dialog("Breaking News:\n%s" % dayNewsReports[Global.currentDay - 1])
	else:
		DialogBox.show_dialog("Breaking News:\n?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????")

func _on_button_pressed() -> void:
	Global.timeSpeedMultiplier = 1.0
	Global.totalMinutes = 6*60
	if Global.queueEnding:
		get_tree().change_scene_to_file("res://Scenes/BaseEndScene.tscn")
		return
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")

func _on_lamp_switch_pressed() -> void:
	$"Lamp Light".visible = !$"Lamp Light".visible
	if $"Lamp Light".visible:
		$CanvasModulate.color = Color(0.325, 0.325, 0.325)
	else:
		$CanvasModulate.color = Color(0.144, 0.144, 0.144)

func _on_shop_button_pressed() -> void:
	$"ButtonLayer/Shop Panel".visible = !$"ButtonLayer/Shop Panel".visible
