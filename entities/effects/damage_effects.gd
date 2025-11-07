class_name DamageEffects
extends Node

@export var directional_splat_scene: PackedScene
@export var floor_splat_scene: PackedScene

# @export_group("Shake on Damage")
# @export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var shake_on_damage: bool = true
# @export var shake_magnitude: float = 5.0

@export_group("Refs")
@export var health: HealthComponent

func _ready():
	assert(health, "DamageEffect requires a HealthComponent reference.")

	health.on_directional_damage.connect(
		func (position: Vector2, direction: Vector2):
			assert(multiplayer.is_server(), "Damage effects should only be triggered on the server.")
			directional_damage_effect.rpc(position, direction)
	)

@rpc("call_local", "authority", "unreliable")
func directional_damage_effect(position: Vector2, direction: Vector2) -> void:
	if directional_splat_scene:
		var blood_splat_instance = directional_splat_scene.instantiate()
		blood_splat_instance.position = position
		blood_splat_instance.rotation = direction.angle()
		add_child(blood_splat_instance)

	if floor_splat_scene:
		var static_splat_instance = floor_splat_scene.instantiate()
		static_splat_instance.position = position
		static_splat_instance.rotation = randf() * TAU
		add_child(static_splat_instance)
