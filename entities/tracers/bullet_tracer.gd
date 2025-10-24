class_name BulletTracer
extends Node2D

var from_position: Vector2
var to_position: Vector2

var speed: float = 10000.0

var distance: float
var direction: Vector2
var traveled_distance: float = 0.0

func _ready():
    global_position = from_position
    look_at(to_position)

    distance = from_position.distance_to(to_position)
    direction = (to_position - from_position).normalized()

func _process(delta):
    traveled_distance += speed * delta
    if traveled_distance >= distance:
        queue_free()
        return

    global_position = from_position + direction * traveled_distance

