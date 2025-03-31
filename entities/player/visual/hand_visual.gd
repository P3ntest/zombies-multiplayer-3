@tool
class_name PlayerHandVisual
extends Node2D

@export var hand_type: VisualHandType = VisualHandType.FIST:
    set(value):
        set_sprite(value)
        hand_type = value

@export var flipped: bool = false:
    set(value):
        flipped = value
        scale.y = -1 if flipped else 1

enum VisualHandType {
    FIST,
    FLASHLIGHT,
    GRAB_AMMO,
    HOLDING_GUN,
    HOLDING_KNIFE,
    STEADYING_GUN,
}

func set_sprite(new_hand_type: VisualHandType):
    for child in get_children():
        if child is Node2D:
            child.visible = false
    
    get_child(new_hand_type).visible = true
