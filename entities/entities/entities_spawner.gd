class_name EntitiesSpawner
extends MultiplayerSpawner

static var instance: EntitiesSpawner = null

func spawn_entity(data: Dictionary) -> Node:
	var uid: int = data.get("uid")
	var transform: Transform2D = data.get("transform", Transform2D.IDENTITY)

	var entity_scene: PackedScene = ResourceLoader.load(
		ResourceUID.id_to_text(uid)
	) as PackedScene

	print("Spawning entity with UID: %d" % uid)
	print("Entity scene: %s" % entity_scene.resource_path)
	print("Client Transform: %s" % transform)

	var entity: Node = entity_scene.instantiate()

	assert(entity is Node2D, "Spawned entity must be a Node2D.")

	entity.transform = transform

	return entity

func _ready():
	spawn_function = spawn_entity
	instance = self

	despawned.connect(func(node: Node) -> void:
		print("Despawning entity: %s" % node.name)
	)

func add_entity(uid: int, transform: Transform2D):
	assert(multiplayer.is_server(), "Only the server can add entities.")

	print("Adding entity with UID: %d" % uid)

	print("Server Transform: %s" % transform)

	var entity_data := {
		"uid": uid,
		"transform": transform,
	}

	# I don't really understand why, but we need to wait a frame here
	await get_tree().process_frame

	return spawn(entity_data) as Node2D