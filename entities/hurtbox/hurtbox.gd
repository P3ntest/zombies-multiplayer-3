class_name HurtBox
extends Area2D

@export var health: HealthComponent

func _ready():
	collision_layer = 0
	set_collision_layer_value(LayerNames.P_HURTBOX, true)

func bullet_hit(bullet: BulletProperties, hit_position: Vector2, bullet_direction: Vector2) -> BulletHit:
	var hit = BulletHit.new()
	hit.penetration_used = 1.0

	var damage: int = bullet.get_damage()
	var stopping_power: float = bullet.get_stopping_power()

	health.damage(damage, stopping_power)

	EffectsManager.instance.spawn_blood_splat(hit_position, bullet_direction)

	# print_debug("HurtBox hit ouch")

	return hit
