class_name PlayerInput
extends BaseNetInput

var move_vector: Vector2 = Vector2.ZERO
var aim_direction: float = 0.0

@onready var player: CharacterBody2D = get_parent() as CharacterBody2D

func _gather():
    move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    
    aim_direction = get_current_aim_direction()

func get_current_aim_direction() -> float:
    var mouse_position: Vector2 = player.get_global_mouse_position()
    var player_position: Vector2 = get_parent().global_position
    return (mouse_position - player_position).angle()