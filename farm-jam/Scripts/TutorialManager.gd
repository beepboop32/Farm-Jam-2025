extends CanvasLayer

@onready var dialog_label: Label = $Background/DialogLabel
@onready var background: TextureRect = $Background
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tutorial_messages: Array[String] = [
	"🌾 Welcome to your farm!\nThis peaceful patch of land is all yours.",
	"🐑 Meet your sheep!\nThese woolly friends rely on you for food and care.",
	"🌽 Feeding time!\nHover over this box and use the scroll wheel to grab some food.",
	"🖱 Click to feed!\nClick on a sheep to feed it — they’ll appreciate it! :D",
	"⚠️ Careful now...\nOverfeeding can upset your sheep or even cause harm. Feed with care!",
	"❤️ Reproduction! \nHappy sheep will reproduce automatically! So make sure to treat them well :D",
	"☠ Doom! \nSurvival is hard, if you run out of food or sheep you may not survive...",
	"⚡ Your energy\nEvery action you take uses energy. Keep an eye on it!",
	"🍖 Low on energy?\nYou can harvest a sheep by clicking it with no food in hand.",
	"🌙 This one’s old...\nThis sheep has lived a full life. Put it down gently to help sustain your farm.",
	"🛒 Capitilsim! \nYou can donate sheep corpses for goverment credits or eat them to sustain yourself :D",
	"⏱ Time controls\nSee the clock? Click it to speed up time when you're ready.",
	"🎉 That’s it!\nYou’re ready to farm — have fun and take care of your flock! :D"
]

var full_text: String = ""
var displayed_text: String = ""
var char_index: int = 0
var typing_speed: float = 0.025
var is_typing: bool = false
var completed: bool = false
var step: int = 0
var skip_requested: bool = false
var message_index: int = 0

func _ready():
	background.modulate.a = 0.0
	animation_player.play("fade_in")
	await animation_player.animation_finished
	_show_next_message()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") or event.is_action_pressed("ui_accept"):
		if is_typing:
			skip_requested = true
		else:
			_show_next_message()

func _show_next_message():
	if message_index >= tutorial_messages.size():
		get_tree().change_scene_to_file("res://Scenes/HomeScene.tscn")
		return
	full_text = tutorial_messages[message_index]
	displayed_text = ""
	char_index = 0
	skip_requested = false
	is_typing = true
	dialog_label.text = ""
	message_index += 1
	typing()

func typing():
	while char_index < full_text.length():
		if skip_requested:
			break
		displayed_text += full_text[char_index]
		dialog_label.text = displayed_text
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout
	dialog_label.text = full_text
	is_typing = false
	skip_requested = false
