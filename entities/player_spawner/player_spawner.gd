class_name PlayerSpawner
extends MultiplayerSpawner

func spawn_player(data: Dictionary) -> Node:
	var peer_id: int = data.get("peer_id")

	var player_character: PlayerCharacter = preload("res://entities/player/player_character.tscn").instantiate()

	player_character.peer_id = peer_id
	player_character.setup_authority()

	LimboConsole.print_line("Spawning player for peer id: %d" % peer_id)

	return player_character

func _ready():
	spawn_function = spawn_player

	NetworkEvents.on_peer_join.connect(
		func(peer_id: int):
			if multiplayer.get_unique_id() == 1:
				spawn({"peer_id": peer_id})
	)

	NetworkEvents.on_server_start.connect(
		func():
			# Spawn the server player
			var server_peer_id: int = multiplayer.get_unique_id()
			spawn({"peer_id": server_peer_id})
	)
