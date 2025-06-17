extends CharacterBody2D

@export var speed := 50
@export var moveDurationRange := Vector2(2, 10)
@export var stopDurationRange := Vector2(1, 2)
@export var SpriteA : Texture2D
@export var SpriteB : Texture2D

var sheep_id: int = -1
var current_hunger: int = 0
var max_hunger: int = 10
var health: int = 100

var moving := false
var timer := 0.0
var moveTime := 0.0
var stopTime := 0.0
var direction := Vector2.ZERO
var waddleAmplitude := 0.15 
var waddleSpeed := 6.0
var waddleTime := 0.0

func _ready() -> void:
	if max_hunger == 10:
		max_hunger = randi_range(5, 25)

	$Sprite2D.material = $Sprite2D.material.duplicate()

	add_to_group("sheep")

	_startMoving()
	var random = randf()
	if random <= 0.8:
		$Sprite2D.texture = SpriteA
	else:
		$Sprite2D.texture = SpriteB

func _process(delta: float) -> void:
	if moving:
		var currentSpeed = speed * Global.speedMultiplier
		velocity.x = direction.x * currentSpeed
		move_and_slide()

		waddleTime += delta * waddleSpeed
		rotation = sin(waddleTime) * waddleAmplitude

		timer += delta
		if timer >= moveTime:
			_startStopping()
	else:
		velocity = Vector2.ZERO
		rotation = 0
		timer += delta
		if timer >= stopTime:
			_startMoving()
	var mouse_pos = get_global_mouse_position()
	var topmost_sheep: CharacterBody2D = null
	var topmost_z := -INF

	for sheep in get_tree().get_nodes_in_group("sheep"):
		if not sheep.has_node("Sprite2D"):
			continue

		var sprite := sheep.get_node("Sprite2D") as Sprite2D
		if not sprite.get_rect().has_point(sprite.to_local(mouse_pos)):
			continue

		if sprite.z_index > topmost_z:
			topmost_z = sprite.z_index
			topmost_sheep = sheep

	if topmost_sheep == self:
		$Sprite2D.material.set_shader_parameter("outline_color", Color(1, 1, 1, 1))
	else:
		$Sprite2D.material.set_shader_parameter("outline_color", Color(1, 1, 1, 0))

func _physics_process(delta: float) -> void:
	if moving:
		var currentSpeed = speed * Global.speedMultiplier
		var collision = move_and_collide(direction * currentSpeed * delta)
		if collision:
			var normal = collision.get_normal()
			var baseAngle = normal.angle()
			var angleOffset = randf_range(-PI/2, PI/2)
			var newAngle = baseAngle + angleOffset
			direction = Vector2(cos(newAngle), sin(newAngle)).normalized()

func _startMoving() -> void:
	moving = true
	timer = 0.0
	moveTime = randf_range(moveDurationRange.x, moveDurationRange.y)
	
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()

func _startStopping() -> void:
	moving = false
	timer = 0.0
	stopTime = randf_range(stopDurationRange.x, stopDurationRange.y)
	velocity = Vector2.ZERO

func set_hunger_health(current: int, max_h: int, hp: int) -> void:
	current_hunger = current
	max_hunger = max_h
	health = hp

func apply_hunger_decay_on_load() -> bool:
	var decay_percent = randf_range(0.1, 0.5)
	current_hunger = int(current_hunger * (1.0 - decay_percent))
	if current_hunger < 0:
		current_hunger = 0
	if sheep_id >= 0 and sheep_id < Global.sheep_data.size():
		Global.sheep_data[sheep_id]["current_hunger"] = current_hunger
	if current_hunger == 0:
		health = 0
		if sheep_id >= 0 and sheep_id < Global.sheep_data.size():
			Global.sheep_data[sheep_id]["health"] = 0
		return true

	return false 
