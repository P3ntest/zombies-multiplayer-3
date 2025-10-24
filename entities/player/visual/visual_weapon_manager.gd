class_name PlayerVisualWeaponManager
extends Node

@export var item_container: Node2D

@export var _equipped_weapon: Weapon

var current_visual: WeaponVisual = null

func get_muzzle_position() -> Node2D:
    if current_visual:
        return current_visual.muzzle_position
    return null

func _ready():
    set_weapon(_equipped_weapon)

func set_weapon_visual(visual: PackedScene) -> void:
    if current_visual:
        current_visual.queue_free()
        current_visual = null
    
    current_visual = visual.instantiate() as WeaponVisual
    item_container.add_child(current_visual)

func set_weapon(weapon: Weapon) -> void:
    _equipped_weapon = weapon

    set_weapon_visual(weapon.visual_scene)