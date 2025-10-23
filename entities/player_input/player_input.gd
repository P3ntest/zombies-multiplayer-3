class_name PlayerInput
extends BaseNetInput

var move_vector: Vector2 = Vector2.ZERO
var aim_direction: float = 0.0
var is_attacking: bool = false
var is_attacking_just: bool = false
var _is_attacking_buffer: bool = false

@onready var player: PlayerCharacter = get_parent() as PlayerCharacter

func _add_inputs_to_rs() -> void:
	var rs: RollbackSynchronizer = player.rs
	rs.add_input(self, "move_vector")
	rs.add_input(self, "aim_direction")
	rs.add_input(self, "is_attacking")
	rs.add_input(self, "is_attacking_just")

func _ready() -> void:
	super._ready()
	_add_inputs_to_rs()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		_is_attacking_buffer = true

func _gather() -> void:
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	aim_direction = get_current_aim_direction()

	is_attacking = Input.is_action_pressed("attack")
	is_attacking_just = _is_attacking_buffer
	_is_attacking_buffer = false

func get_current_aim_direction() -> float:
	var mouse_position: Vector2 = player.get_global_mouse_position()
	var player_position: Vector2 = get_parent().global_position
	return (mouse_position - player_position).angle()
