class_name SpeedController
extends Node

@export var base_speed: float = 300.0

@export_group("Components")
@export var health_component: HealthComponent
@export var weapon_component: WeaponAttackController

func get_current_speed() -> float:
	return base_speed * get_speed_multiplier()

func get_speed_multiplier() -> float:
	var speed_multiplier: float = 1.0

	if health_component:
		speed_multiplier *= health_component.get_speed_multiplier()

	if weapon_component:
		var equipped_weapon: Weapon = weapon_component.get_current_weapon()
		speed_multiplier *= equipped_weapon.movement_speed_multiplier
		if weapon_component.is_currently_attacking():
			speed_multiplier *= equipped_weapon.movement_speed_shoot_multiplier

	return speed_multiplier
