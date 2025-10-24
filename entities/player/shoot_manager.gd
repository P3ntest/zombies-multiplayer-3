extends Node

@onready var player_character: PlayerCharacter = get_parent() as PlayerCharacter
@onready var input := player_character.input

var bullet_raycast: BulletRaycast

func _ready():
	bullet_raycast = BulletRaycast.new()
	add_child(bullet_raycast)

func shoot():
	var muzzle_position: Node2D = player_character.player_visual.weapon_manager.get_muzzle_position()
	if muzzle_position == null:
		return
	
	var bullet := BulletProperties.new()
	# TODO: Configure bullet properties here

	var report := bullet_raycast.trace_bullet(
		bullet,
		muzzle_position.global_position,
		Vector2.RIGHT.rotated(input.aim_direction))


	TracerManager.instance.spawn_tracer(
		muzzle_position.global_position,
		report.final_position)

func _rollback_tick(_delta, _tick, is_fresh):
	if not multiplayer.is_server():
		return

	if not is_fresh:
		return

	if input.is_attacking_just:
		print("shooot")
		shoot()
