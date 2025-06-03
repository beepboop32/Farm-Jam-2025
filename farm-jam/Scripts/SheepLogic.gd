extends CharacterBody2D

@export var speed := 50
@export var moveDurationRange := Vector2(2, 10)
@export var stopDurationRange := Vector2(1, 2)
@export var jumpStrength := 250.0
@export var gravity := 800.0

var moving := false
var timer := 0.0
var moveTime := 0.0
var stopTime := 0.0
var direction := Vector2.ZERO
var waddleAmplitude := 0.15 
var waddleSpeed := 6.0
var waddleTime := 0.0
var verticalVelocity := 0.0

func _ready() -> void:
	_startMoving()

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
