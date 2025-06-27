extends Node2D

@export var bullet_texture: Texture2D
@export var spacing: int = 8
@export var max_bullets: int = 6

var bullet_sprites: Array = []

func _ready():
	for i in range(max_bullets):
		var sprite = Sprite2D.new()
		sprite.texture = bullet_texture
		sprite.position = Vector2(i * (bullet_texture.get_width() + spacing), 0)
		add_child(sprite)
		bullet_sprites.append(sprite)
	_update_bullets()

func _process(_delta):
	_update_bullets()

func _update_bullets():
	var bullets_left = clamp(Global.bullets, 0, max_bullets)
	for i in range(max_bullets):
		if i < bullets_left:
			bullet_sprites[i].modulate = Color(1,1,1,1)
		else:
			bullet_sprites[i].modulate = Color(1,1,1,0.2) # faded for empty
