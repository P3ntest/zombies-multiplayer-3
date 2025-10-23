class_name Weapon
extends Resource

@export var id: String = "-"

## Scene for the visual part, when held in hand. Must extend WeaponVisual.
@export var visual_scene: PackedScene

@export_group("Animations")
@export var idle_animation: String = "gun_long_idle"
@export var shoot_animation: String = "gun_long_shoot"