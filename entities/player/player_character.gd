class_name PlayerCharacter
extends CharacterBody2D

const PEER_ID_UNASSIGNED: int = -1
const PEER_ID_SERVER: int = 1

var peer_id: int = PEER_ID_UNASSIGNED

@export var input: PlayerInput
@export var camera: Camera2D

@export var rs: RollbackSynchronizer

@onready var player_visual: PlayerVisual = $PlayerVisual

func setup_authority():
	set_multiplayer_authority(PEER_ID_SERVER)
	input.set_multiplayer_authority(peer_id)

func _process(delta):
	if peer_id == multiplayer.get_unique_id():
		rotation = input.get_current_aim_direction()

func _ready():
	if peer_id == multiplayer.get_unique_id():
		camera.make_current()

func _rollback_tick(delta, tick, is_fresh):
	velocity = input.move_vector.normalized() * 200.0

	rotation = input.aim_direction

	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
