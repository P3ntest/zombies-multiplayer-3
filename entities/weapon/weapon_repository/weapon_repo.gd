class_name WeaponRepo
extends Resource

static var _instance = preload("res://entities/weapon/weapon_repository/repo.tres")

static var id_cache: Dictionary[String, Weapon] = {}

static func get_weapon_by_id(weapon_id: String) -> Weapon:
    if id_cache.has(weapon_id):
        return id_cache[weapon_id]
    
    for weapon in _instance.weapons:
        if weapon.id == weapon_id:
            id_cache[weapon_id] = weapon
            return weapon
    
    push_error("Weapon with ID '%s' not found in repository." % weapon_id)
    return null

@export var weapons: Array[Weapon] = []