extends Node

@export var health: HealthComponent

func _ready():
    health.health_depleted.connect(func ():
        print("Queuing entity for deletion on peer id %d" % multiplayer.get_unique_id())
        get_parent().queue_free()
        )
