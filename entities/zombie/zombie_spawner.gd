class_name ZombieSpawner
extends MultiplayerSpawner

func spawn_zombie(data: Dictionary) -> Node:
	var zombie_character = preload("res://entities/zombie/zombie_character.tscn").instantiate()

	return zombie_character

func _ready():
	spawn_function = spawn_zombie

func temp_add_zombie():
	if not multiplayer.is_server():
		print("Only the server can add zombies.")
		return

	# I don't really understand why, but we need to wait a frame here
	# Here not needed but for entities spawner needed so added for consistency
	await get_tree().process_frame
	
	spawn({})
