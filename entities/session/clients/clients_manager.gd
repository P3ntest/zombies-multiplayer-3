class_name ClientsManager
extends Node

@export var users: NetUsersManager

func _ready():
    if not SessionParent.is_server():
        return  # Only the server manages

    if SessionParent.has_local_player():
        users.add_user(multiplayer.get_unique_id())

    NetworkEvents.on_peer_join.connect(func(peer_id: int):
        users.add_user(peer_id)
    )
