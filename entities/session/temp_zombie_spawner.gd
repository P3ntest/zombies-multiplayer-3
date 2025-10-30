extends Timer

const zombie_scene: PackedScene = preload("res://entities/zombie/zombie_character.tscn")

func _ready():
    if multiplayer.is_server():
        timeout.connect(func():
            var zombie_instance = zombie_scene.instantiate()
            get_parent().add_child(zombie_instance)
            )
