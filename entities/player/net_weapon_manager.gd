class_name NetWeaponManager
extends Node

@onready var player: PlayerCharacter = get_parent() as PlayerCharacter
@onready var player_visual: PlayerVisual = player.player_visual
@onready var visual_weapon_manager: PlayerVisualWeaponManager = player_visual.weapon_manager

func play_animation(animation: Weapon.WeaponAnimation) -> void:
	assert(multiplayer.is_server(), "play_animation should only be called on the server.")
	_play_animation.rpc(animation)

@rpc("authority", "call_local")
func _play_animation(animation: Weapon.WeaponAnimation) -> void:
	var animation_handler: PlayerVisualWeaponAnimationHandler = player_visual.animation_handler
	match animation:
		Weapon.WeaponAnimation.SHOOT:
			animation_handler._play_shoot()
		_:
			push_error("Unknown weapon animation: %s" % animation)

func equip_weapon(weapon_id: String) -> void:
	assert(multiplayer.is_server(), "equip_weapon should only be called on the server.")
	equipped_weapon = weapon_id

var equipped_weapon: String = "":
	set(value):
		equipped_weapon = value
		_set_weapon(value)

var _equpped_weapon_object: Weapon = null

func _set_weapon(weapon_id: String) -> void:
	_equpped_weapon_object = WeaponRepo.get_weapon_by_id(weapon_id)
	visual_weapon_manager.set_weapon(_equpped_weapon_object)
