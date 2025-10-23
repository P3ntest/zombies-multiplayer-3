extends Node

const session_prefab := preload("res://entities/session/game_session.tscn")

var current_session: Node = null

func _ready():
    current_session = session_prefab.instantiate()
    add_child(current_session)
    
    var peer = ENetMultiplayerPeer.new()
    if OS.get_cmdline_args().has("--join"):
        peer.create_client("localhost", 12345)
        print("Connecting to server at localhost:12345")
        get_window().title = "Client"
    else:
        peer.create_server(12345)
        print("Hosting server on port 12345")
        get_window().title = "Server"

    multiplayer.multiplayer_peer = peer
