extends Node

@onready var player_character: PlayerCharacter = get_parent() as PlayerCharacter
@onready var input := player_character.input

func _rollback_tick(_delta, _tick, is_fresh):
	if not multiplayer.is_server():
		return

	if not is_fresh:
		return

	if input.is_attacking_just:
		print("shooot")
		TracerManager.instance.spawn_tracer(
			player_character.global_position,
			Vector2.ZERO)  # Placehold	er for target position
