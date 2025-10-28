extends Node2D

@onready var partices: GPUParticles2D = $GPUParticles2D

func _ready():
    partices.emitting = true
    partices.finished.connect(queue_free)