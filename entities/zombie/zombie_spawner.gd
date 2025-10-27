class_name ZombieSpawner
extends MultiplayerSpawner

func spawn_zombie(data: Dictionary) -> Node:
	var zombie_character = preload("res://entities/zombie/zombie_character.tscn").instantiate()

	return zombie_character

func _ready():
	spawn_function = spawn_zombie

func temp_add_zombie():
	spawn({})
