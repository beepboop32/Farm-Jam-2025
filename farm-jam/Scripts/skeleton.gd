extends Node2D

signal dropped

var dragging := false

func _ready():
    add_to_group("skeletons")

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed and get_global_rect().has_point(get_global_mouse_position()):
                dragging = true
            elif not event.pressed and dragging:
                dragging = false
                emit_signal("dropped")
    elif event is InputEventMouseMotion and dragging:
        global_position += event.relative

func get_global_rect() -> Rect2:
    if has_node("Sprite2D"):
        var sprite = $Sprite2D
        var size = sprite.texture.get_size() * sprite.scale
        return Rect2(global_position - size / 2, size)
    return Rect2()