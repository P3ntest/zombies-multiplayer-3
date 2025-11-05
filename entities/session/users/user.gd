class_name NetUser
extends Node

var player_spawner: PlayerSpawner

var username: String = "Guest"
var peer_id: int = -1

var character: PlayerCharacter = null

func spawn():
	assert( character == null , "User %s is already spawned!" % username )
	character = player_spawner.spawn({
		"peer_id": peer_id,
	})

func _ready():
	spawn()    
