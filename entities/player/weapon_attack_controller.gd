class_name WeaponAttackController
extends Node

@onready var player_character: PlayerCharacter = get_parent() as PlayerCharacter
@onready var input := player_character.input
@onready var weapon_manager: NetWeaponManager = player_character.net_weapon

var bullet_raycast: BulletRaycast

func get_current_weapon() -> Weapon:
	return weapon_manager.get_equipped_weapon()

func is_currently_attacking() -> bool:
	return NetworkTime.tick < cooldown_until

func _ready():
	bullet_raycast = BulletRaycast.new()
	add_child(bullet_raycast)

func shoot(gun: Weapon, current_tick: int) -> void:
	var muzzle_position: Node2D = player_character.player_visual.weapon_manager.get_muzzle_position()
	if muzzle_position == null:
		return


	if gun.is_shotgun:
		_fire_shotgun(
			gun,
			muzzle_position.global_position,
			player_character.rotation
		)
	else:
		_fire_non_shotgun(
			gun,
			muzzle_position.global_position,
			player_character.rotation
		)

	weapon_manager.play_animation(Weapon.WeaponAnimation.SHOOT)

	cooldown_until = gun.shoot_cooldown_ticks() + current_tick

func _fire_shotgun(gun: Weapon, from_position: Vector2, direction: float) -> void:
	var num_pellets: int = gun.shotgun_pellet_count
	for i in num_pellets:
		var bullet := gun.create_bullet()

		var pellet_angle: float = gun.shotgun_spread * ((float(i) / float(num_pellets - 1)) - 0.5)

		var spread_angle: float = randf_range(-gun.base_spread, gun.base_spread) / 10

		var shot_direction: float = direction + spread_angle + pellet_angle

		_fire_bullet(bullet, from_position, shot_direction)

func _fire_non_shotgun(gun: Weapon, from_position: Vector2, direction: float) -> void:
	var bullet := gun.create_bullet()

	var spread_angle: float = randf_range(-gun.base_spread, gun.base_spread) / 10

	var shot_direction: float = direction + spread_angle

	_fire_bullet(bullet, from_position, shot_direction)

func _fire_bullet(bullet: BulletProperties, from_position: Vector2, direction: float) -> void:
	var direction_vec: Vector2 = Vector2.RIGHT.rotated(direction)
	var report := bullet_raycast.trace_bullet(bullet, from_position, direction_vec)

	EffectsManager.instance.spawn_tracer(
		from_position,
		report.final_position)

var cooldown_until: int = -1

func check_shoot(just_pressed: bool, current_tick: int) -> void:
	if not get_current_weapon().is_gun:
		return

	var gun: Weapon = weapon_manager.get_equipped_weapon()

	if not gun.is_automatic and not just_pressed:
		return

	if current_tick < cooldown_until:
		return

	shoot(gun, current_tick)

func _rollback_tick(_delta, tick, is_fresh):
	if not multiplayer.is_server():
		return

	if not is_fresh:
		return

	if input.is_attacking:
		check_shoot(input.is_attacking_just, tick)
