class_name TracerManager
extends Node2D

static var instance: TracerManager = null

const tracer_scene := preload("res://entities/tracers/bullet_tracer.tscn")

func _ready():
    instance = self

func spawn_tracer(start_position: Vector2, end_position: Vector2):
    assert(multiplayer.is_server(), "Only the server can spawn tracers.")

    _spawn_tracer_net.rpc(start_position, end_position)

@rpc("authority", "call_local", "reliable")
func _spawn_tracer_net(start_position: Vector2, end_position: Vector2):
    var tracer_instance: BulletTracer = tracer_scene.instantiate()
    tracer_instance.from_position = start_position
    tracer_instance.to_position = end_position
    add_child(tracer_instance)
    # var distance: float = start_position.distance_to(end_position)
    # tracer_instance.scale = Vector2(distance / tracer_instance.texture.get_size().x, 1)
