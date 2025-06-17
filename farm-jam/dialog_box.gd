extends CanvasLayer

@onready var dialog_label: Label = $Background/DialogLabel
@onready var background: TextureRect = $Background
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var full_text: String = ""
var displayed_text: String = ""
var char_index: int = 0
var typing_speed: float = 0.03 
var is_typing: bool = false
var skip_requested: bool = false

func show_dialog(text: String):
	full_text = text
	displayed_text = ""
	char_index = 0
	skip_requested = false
	is_typing = true
	dialog_label.text = ""
	
	# Show and start fade-in animation
	show()
	background.modulate.a = 0.0
	animation_player.play("fade_in")

	_start_typing()

func _start_typing():
	typing()

func typing():
	while char_index < full_text.length():
		if skip_requested:
			break
		displayed_text += full_text[char_index]
		dialog_label.text = displayed_text
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout

	# Finish typing
	dialog_label.text = full_text
	is_typing = false
	skip_requested = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if is_typing:
			skip_requested = true
		else:
			hide()
