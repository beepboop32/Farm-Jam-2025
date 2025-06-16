extends Node2D

@export var dotMinX := -10.0
@export var dotMaxX := 10.0
@export var slideSpeed := 5.0
@export var fadeSpeed := 4.0  # Higher = faster fade

@export var lowSanityTexture: Texture2D
@export var midSanityTexture: Texture2D
@export var highSanityTexture: Texture2D

@onready var dot := $"SanityMeter/Sanity Face"

var currentX := 0.0
var currentCategory := ""
var fadeOut := false
var fadeIn := false

func _ready() -> void:
	currentX = lerp(dotMinX, dotMaxX, clamp(Global.sanity, 0.0, 1.0))
	dot.position.x = currentX
	currentCategory = _getCategory(Global.sanity)
	dot.texture = _getTexture(currentCategory)
	dot.modulate.a = 1.0

func _process(delta: float) -> void:
	# Move dot smoothly
	var targetX = lerp(dotMinX, dotMaxX, clamp(Global.sanity, 0.0, 1.0))
	currentX = lerp(currentX, targetX, delta * slideSpeed)
	dot.position.x = currentX

	# Update texture with fade
	_updateDotTexture(delta)

func _getCategory(sanity: float) -> String:
	if sanity < 0.34:
		return "low"
	elif sanity < 0.67:
		return "mid"
	else:
		return "high"

func _getTexture(category: String) -> Texture2D:
	match category:
		"low": return lowSanityTexture
		"mid": return midSanityTexture
		"high": return highSanityTexture
	return null

func _updateDotTexture(delta: float) -> void:
	var sanity = clamp(Global.sanity, 0.0, 1.0)
	var newCategory = _getCategory(sanity)

	if newCategory != currentCategory and not fadeOut and not fadeIn:
		fadeOut = true

	if fadeOut:
		dot.modulate.a = max(dot.modulate.a - delta * fadeSpeed, 0.0)
		if dot.modulate.a <= 0.0:
			dot.texture = _getTexture(newCategory)
			currentCategory = newCategory
			fadeOut = false
			fadeIn = true

	elif fadeIn:
		dot.modulate.a = min(dot.modulate.a + delta * fadeSpeed, 1.0)
		if dot.modulate.a >= 1.0:
			fadeIn = false
