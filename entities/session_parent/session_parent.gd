extends Node

const session_prefab := preload("res://entities/session/game_session.tscn")

var current_session: Node = null

func is_in_active_session() -> bool:
    return current_session != null and multiplayer.multiplayer_peer != null

func kill_session_world():
    if current_session:
        current_session.queue_free()
        current_session = null

func reset_session_world():
    kill_session_world()

    current_session = session_prefab.instantiate()
    add_child(current_session)

func connect_to_server(address: String = "localhost", port: int = 12345):
    if is_in_active_session():
        print("Already in active session, disconnecting first.")
        disconnect_from_server()

    print("Resetting session world and connecting to server...")
    reset_session_world()
    var peer = ENetMultiplayerPeer.new()
    print("Creating client peer...")
    peer.create_client(address, port)
    LimboConsole.print_line("Connecting to server at %s:%d" % [address, port])
    get_window().title = "Client"
    multiplayer.multiplayer_peer = peer

func start_server(port: int = 12345):
    if is_in_active_session():
        disconnect_from_server()

    reset_session_world()
    var peer = ENetMultiplayerPeer.new()
    # make it work from inside docker
    # peer.set_bind_ip("0.0.0.0")
    peer.create_server(port)
    LimboConsole.print_line("Starting server on port %d" % port)
    get_window().title = "Server"
    multiplayer.multiplayer_peer = peer

func disconnect_from_server():
    LimboConsole.print_line("Disconnecting from Multiplayer session.")
    multiplayer.multiplayer_peer.close()
    multiplayer.multiplayer_peer = null
    kill_session_world()

func _ready():
    if OS.get_cmdline_args().has("--join"):
        # var address_index = OS.get_cmdline_args().find("--join") + 1
        var address = "localhost"
        # if address_index < OS.get_cmdline_args().size():
        #     address = OS.get_cmdline_args()[address_index]

        # var port_index = OS.get_cmdline_args().find("--port") + 1
        var port = 12345
        # if port_index < OS.get_cmdline_args().size():
        #     port = int(OS.get_cmdline_args()[port_index])

        print("Read from args to connect to server at %s:%d" % [address, port])
        connect_to_server(address, port)
    else:
        print("No --join arg found, starting server...")
        start_server()

    LimboConsole.register_command(connect_to_server, "connect")
    LimboConsole.register_command(start_server, "host")
    LimboConsole.register_command(disconnect_from_server, "disconnect")

    multiplayer.connected_to_server.connect(
        func():
            LimboConsole.print_line("Connected to server.")
    )

func _process(_delta):
    pass
    # print(multiplayer.multiplayer_peer.get_connection_status())    