class_name HealthComponent
extends Node

signal health_depleted()
signal health_changed(current_health: int)

@export var max_health: int = 100

@onready var current_health: int = max_health

@export var max_slowed: float = 1.0
@export var slowed_recovery_rate: float = 1.0
var current_slowed: float = 0.0

func slowed_percentage() -> float:
    return current_slowed / max_slowed

func get_speed_multiplier() -> float:
    return 1.0 - slowed_percentage()

func _remove_health(health_amount: int) -> void:
    if current_health <= 0:
        return

    current_health = max(current_health - health_amount, 0)

    if current_health == 0:
        health_depleted.emit()

    health_changed.emit(current_health)

func _slow(slowed_amount: float) -> void:
    current_slowed = min(current_slowed + slowed_amount, max_slowed)

func damage(health_amount: int, slowed_amount: float) -> void:
    assert(multiplayer.is_server(), "HealthComponent.damage should only be called on the server.")

    _remove_health(health_amount)
    _slow(slowed_amount)

    print_debug("HealthComponent damaged: -%d health, -%f slowed" % [health_amount, slowed_amount])

func _physics_process(delta: float) -> void:
    if current_slowed > 0.0:
        current_slowed = max(current_slowed - delta * slowed_recovery_rate, 0.0)


