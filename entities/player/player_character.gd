extends CharacterBody2D

func _process(delta):
    # look at the mouse position
    look_at(get_global_mouse_position())