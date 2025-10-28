class_name PlayerCharacter
extends CharacterBody2D

const PEER_ID_UNASSIGNED: int = -1
const PEER_ID_SERVER: int = 1

var peer_id: int = PEER_ID_UNASSIGNED

@export_group("Refs")
@export var input: PlayerInput
@export var camera: Camera2D
@export var rs: RollbackSynchronizer
@export var ms: MultiplayerSynchronizer
@export var player_visual: PlayerVisual
@export var net_weapon: NetWeaponManager
@export var speed_controller: SpeedController
@export var health_component: HealthComponent

func setup_authority():
	set_multiplayer_authority(PEER_ID_SERVER)
	input.set_multiplayer_authority(peer_id)

func _process(_delta: float) -> void:
	if peer_id == multiplayer.get_unique_id():
		rotation = input.get_current_aim_direction()

func _ready() -> void:
	if peer_id == multiplayer.get_unique_id():
		camera.make_current()

	add_to_group(GroupNames.PLAYER_CHARACTER)

	print("Checking to see if we should equip a weapon...")
	if multiplayer.is_server():
		print("Equipping rifle for player with peer id %d" % peer_id)
		net_weapon.equip_weapon("rifle")
	else:
		print("Not the server, not equipping weapon.")

func _rollback_tick(delta: float, _tick, _is_fresh):
	var wish_dir: Vector2 = input.move_vector.normalized() * speed_controller.get_current_speed()

	velocity = velocity.lerp(wish_dir, 20 * delta)

	rotation = input.aim_direction

	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
