class_name NetUsersManager
extends Node

@export var player_spawner: PlayerSpawner

func add_user(peer_id: int) -> NetUser:
    var user := NetUser.new()
    user.player_spawner = player_spawner
    user.username = "Player_%d" % peer_id
    user.peer_id = peer_id
    add_child(user)
    return user