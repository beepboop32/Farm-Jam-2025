extends CanvasLayer

@export var wheat_texture: Texture2D
@export var pointer_texture: Texture2D
@export var hand_texture: Texture2D
@export var target_texture: Texture2D
@export var skeleton_scene: PackedScene
@export var ghost_scene: PackedScene # <-- Add this line

var max_food_hand := 10

var cursor_sprite := Sprite2D.new()
var wheat_container := Node2D.new()

func _ready():
    cursor_sprite.texture = pointer_texture
    add_child(wheat_container)
    add_child(cursor_sprite)
    cursor_sprite.z_index = 1000
    wheat_container.z_index = 1000
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    Global.foodInHand = 0
    set_process_unhandled_input(true)

func _process(_delta):
    var mouse_pos = get_viewport().get_mouse_position()
    cursor_sprite.global_position = mouse_pos
    wheat_container.global_position = mouse_pos
    Global.foodInHand = max(Global.foodInHand, 0)

    var sheep_hovered := false
    if Global.foodInHand == 0:
        for sheep in get_tree().get_nodes_in_group("sheep"):
            if not sheep.has_node("Sprite2D"):
                continue
            var sprite := sheep.get_node("Sprite2D") as Sprite2D
            if sprite.get_rect().has_point(sprite.to_local(mouse_pos)):
                sheep_hovered = true
                break

    if Global.foodInHand > 0:
        cursor_sprite.visible = false
        _update_wheat_sprites()
    else:
        cursor_sprite.visible = true
        cursor_sprite.scale = Vector2.ONE * 2.0
        _clear_wheat_sprites()
        if sheep_hovered:
            cursor_sprite.texture = target_texture
        else:
            cursor_sprite.texture = pointer_texture

var wheat_rotations := []

func _update_wheat_sprites():
    var count = clamp(Global.foodInHand, 0, max_food_hand)
    var current_count = wheat_container.get_child_count()
    if count > current_count:
        for i in range(count - current_count):
            var s = Sprite2D.new()
            s.texture = wheat_texture
            wheat_container.add_child(s)
            wheat_rotations.append(randf_range(-0.785, 0.785))
    elif count < current_count:
        for i in range(current_count - 1, count - 1, -1):
            var s = wheat_container.get_child(i)
            if s:
                s.queue_free()
                wheat_rotations.remove_at(i)
    for i in range(count):
        var s = wheat_container.get_child(i)
        if s:
            s.position = Vector2(0, -i * 1.5)
            s.rotation = wheat_rotations[i]
            s.scale = Vector2.ONE * 1.5
func _clear_wheat_sprites():
    for i in range(wheat_container.get_child_count() - 1, -1, -1):
        var s = wheat_container.get_child(i)
        if s:
            s.queue_free()


func _on_area_2d_mouse_entered() -> void:
    cursor_sprite.texture = hand_texture


func _on_area_2d_mouse_exited() -> void:
    cursor_sprite.texture = pointer_texture

func _unhandled_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        if Global.foodInHand == 0 and Global.bullets > 0:
            var mouse_pos = get_viewport().get_mouse_position()
            for sheep in get_tree().get_nodes_in_group("sheep"):
                if not sheep.has_node("Sprite2D"):
                    continue
                var sprite := sheep.get_node("Sprite2D") as Sprite2D
				if sprite.get_rect().has_point(sprite.to_local(mouse_pos)):
                    # Spawn skeleton at sheep's position
					if skeleton_scene:
						print("Spawning skeleton at sheep's position")
                        var skeleton = skeleton_scene.instantiate()
                        skeleton.global_position = sheep.global_position
                        get_tree().current_scene.add_child(skeleton)
                    # Spawn ghost at sheep's position
					if ghost_scene:
						print("Spawning ghost at sheep's position")
                        var ghost = ghost_scene.instantiate()
                        ghost.global_position = sheep.global_position
                        get_tree().current_scene.add_child(ghost)
                        var tween = get_tree().create_tween()
                        tween.tween_property(ghost, "position:y", ghost.position.y - 100, 1.5)
                        tween.tween_property(ghost, "modulate:a", 0.0, 1.5)
                        tween.finished.connect(func(): ghost.queue_free())
                    # Kill the sheep
                    sheep.health = 0
                    if sheep.sheep_id >= 0 and sheep.sheep_id < Global.sheep_data.size():
                        Global.sheep_data[sheep.sheep_id]["health"] = 0
                    sheep.queue_free()
                    Global.bullets -= 1
                    break