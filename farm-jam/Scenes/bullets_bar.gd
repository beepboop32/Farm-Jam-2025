extends TextureProgressBar

@export var bullet_texture: Texture2D

func _ready():
	max_value = 6
	value = Global.bullets
	texture_under = null
	texture_progress = bullet_texture

func _process(_delta):
	value = Global.bullets
