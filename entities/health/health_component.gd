extends Node

@export var max_health: int = 100
var current_health: int = max_health

func _ready():
    current_health = max_health
