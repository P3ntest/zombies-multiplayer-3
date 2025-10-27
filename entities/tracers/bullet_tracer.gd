class_name BulletTracer
extends Node2D

var from_position: Vector2
var to_position: Vector2

var speed: float = 14000.0

var distance: float
var direction: Vector2
var traveled_distance: float = 0.0

var first_frame_done: bool = false

func _ready():
    global_position = from_position
    look_at(to_position)

    distance = from_position.distance_to(to_position)
    direction = (to_position - from_position).normalized()

func _process(delta: float) -> void:
    if not first_frame_done: # TODO: can be removed when actual muzzle flash is implemented
        first_frame_done = true
        return

    traveled_distance += speed * delta
    if traveled_distance >= distance:
        queue_free()
        return

    global_position = from_position + direction * traveled_distance

