extends Node

@onready var player_character: PlayerCharacter = get_parent() as PlayerCharacter
@onready var input := player_character.input
@onready var weapon_manager: NetWeaponManager = player_character.net_weapon

var bullet_raycast: BulletRaycast

func _ready():
	bullet_raycast = BulletRaycast.new()
	add_child(bullet_raycast)

func shoot(gun: Weapon, current_tick: int) -> void:
	var muzzle_position: Node2D = player_character.player_visual.weapon_manager.get_muzzle_position()
	if muzzle_position == null:
		return
	
	var bullet := BulletProperties.new()

	bullet.base_damage = gun.bullet_base_damage
	bullet.stopping_power = gun.bullet_base_stopping_power
	bullet.penetration_left = gun.bullet_base_penetration
	bullet.max_distance = gun.bullet_max_distance

	var spread_angle: float = randf_range(-gun.base_spread, gun.base_spread) / 10

	var shot_direction: float = input.aim_direction + spread_angle

	var report := bullet_raycast.trace_bullet(
		bullet,
		muzzle_position.global_position,
		Vector2.RIGHT.rotated(shot_direction))

	weapon_manager.play_animation(Weapon.WeaponAnimation.SHOOT)


	EffectsManager.instance.spawn_tracer(
		muzzle_position.global_position,
		report.final_position)

	cooldown_until = gun.shoot_cooldown_ticks() + current_tick

var cooldown_until: int = -1

func check_shoot(just_pressed: bool, current_tick: int) -> void:
	if not weapon_manager._equpped_weapon_object.is_gun:
		return

	var gun: Weapon = weapon_manager._equpped_weapon_object

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
