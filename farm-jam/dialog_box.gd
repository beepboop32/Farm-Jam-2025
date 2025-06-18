extends CanvasLayer

@onready var dialog_label: Label = $Background/DialogLabel
@onready var background: Control = $Background

var full_text: String = ""
var text_chunks: Array = []
var current_chunk_index: int = 0
var char_index: int = 0
var displayed_text: String = ""
var typing_speed: float = 0.03
var is_typing: bool = false
var skip_requested: bool = false
var waiting_for_click: bool = false
var exists: bool = false

func show_dialog(text: String):
	full_text = text
	exists = true
	text_chunks = _split_into_chunks(full_text, 20)
	current_chunk_index = 0
	_show_chunk(current_chunk_index)
	show()
	_fade_in_background()

func _split_into_chunks(text: String, words_per_chunk: int) -> Array:
	var words = text.split(" ")
	var chunks: Array = []
	for i in range(0, words.size(), words_per_chunk):
		chunks.append(" ".join(words.slice(i, i + words_per_chunk)))
	return chunks

func _show_chunk(index: int):
	if index >= text_chunks.size():
		exists = false
		hide()
		return

	displayed_text = ""
	char_index = 0
	skip_requested = false
	is_typing = true
	waiting_for_click = false
	dialog_label.text = ""
	full_text = text_chunks[index]
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
	waiting_for_click = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		if is_typing:
			skip_requested = true
		elif waiting_for_click:
			current_chunk_index += 1
			_show_chunk(current_chunk_index)

func _fade_in_background():
	background.modulate.a = 0.0
	background.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(background, "modulate:a", 1.0, 0.5)
