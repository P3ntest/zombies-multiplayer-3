class_name Weapon
extends Resource

enum WeaponAnimation {
    SHOOT,
}

@export var id: String = "-"

## Scene for the visual part, when held in hand. Must extend WeaponVisual.
@export var visual_scene: PackedScene

@export var movement_speed_multiplier: float = 1.0
@export var movement_speed_shoot_multiplier: float = 1.0

@export_group("Gun")
@export var is_gun: bool = true
@export var bullet_base_damage: int = 10
@export var bullet_base_penetration: float = 1.0
@export var bullet_base_stopping_power: float = 1.0
@export var bullet_max_distance: float = 2000.0
@export var base_spread: float = 0.1
@export var is_automatic: bool = true
@export var base_fire_rate_rps: float = 1.0

@export_group("Gun Buckshot")
@export var is_shotgun: bool = false
@export var shotgun_pellet_count: int = 6
## In radians
@export var shotgun_spread: float = 0.5

func shoot_cooldown_ticks() -> int:
    return int(floor((1.0 / base_fire_rate_rps) * NetworkTime.tickrate))

@export_group("Animations")
@export var idle_animation: String = "gun_long_idle"
@export var shoot_animation: String = "gun_long_shoot"

func create_bullet() -> BulletProperties:
    var bullet := BulletProperties.new()
    bullet.base_damage = bullet_base_damage
    bullet.penetration_left = bullet_base_penetration
    bullet.stopping_power = bullet_base_stopping_power
    bullet.max_distance = bullet_max_distance
    print("created bullet with %d stopping power %d (weapon: %s)" % [bullet.stopping_power, bullet_base_stopping_power, id])
    return bullet