extends Node

@export var health: HealthComponent

func _ready():
    health.health_depleted.connect(get_parent().queue_free)