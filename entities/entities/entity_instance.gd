@tool
class_name EntityInstance
extends Node2D

@export var scene: PackedScene:
	set(value):
		scene = value
		if scene:
			scene_uid = ResourceLoader.get_resource_uid(scene.resource_path)
		update_preview()

@export_storage var scene_uid: int

func _ready():
	if Engine.is_editor_hint():
		return

	assert(scene, "EntityInstance scene must be set before runtime.")
	assert(scene_uid > 0, "EntityInstance scene_uid must be set before runtime.")


	# Check if we are the server, because only the server should instantiate entities
	if not multiplayer.is_server():
		queue_free()
		return

	EntitiesSpawner.instance.add_entity(scene_uid, transform)
	queue_free()

var current_preview: Node = null
func update_preview():
	if not Engine.is_editor_hint():
		return

	if current_preview:
		current_preview.queue_free()
		current_preview = null

	if scene:
		current_preview = scene.instantiate()
		add_child(current_preview)
	
