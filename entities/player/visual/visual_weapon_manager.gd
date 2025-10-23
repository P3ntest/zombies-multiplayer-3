class_name PlayerVisualWeaponManager
extends Node

@export var item_container: Node2D

@export var _equipped_weapon: Weapon

var current_visual: WeaponVisual = null

func set_weapon_visual(visual: PackedScene) -> void:
    if current_visual:
        current_visual.queue_free()
        current_visual = null
    
    current_visual = visual.instantiate() as WeaponVisual
    item_container.add_child(current_visual)

func set_weapon(weapon: Weapon) -> void:
    _equipped_weapon = weapon

    set_weapon_visual(weapon.visual_scene)