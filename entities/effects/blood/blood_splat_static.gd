extends Node2D

const DECAY: float = 0.02

var opacity: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
    rotation = randf() * TAU
    scale *= randf_range(0.5, 1.5)

    sprite.modulate.r += randf_range(-0.3, 0.3)

func _process(delta):
    opacity -= DECAY * delta
    if opacity <= 0.0:
        queue_free()
    else:
        modulate.a = opacity