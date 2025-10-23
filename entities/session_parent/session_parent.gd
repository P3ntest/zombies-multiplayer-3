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
        print(peer.get_connection_status())
    else:
        # make it work from inside docker
        peer.set_bind_ip("0.0.0.0")
        peer.create_server(12345)
        print("Binding server to port 12345")
        print("Binding IP: %s" % "0.0.0.0")
        get_window().title = "Server"

    multiplayer.multiplayer_peer = peer

func _process(_delta):
    pass
    # print(multiplayer.multiplayer_peer.get_connection_status())    