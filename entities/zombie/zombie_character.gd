extends CharacterBody2D

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.health_depleted.connect(_on_health_depleted)

func _on_health_depleted() -> void:
	queue_free()

var current_target: PlayerCharacter = null

func _physics_process(_delta: float) -> void:

	if not current_target:
		var targets := get_tree().get_nodes_in_group(GroupNames.PLAYER_CHARACTER)

		var closest_target: PlayerCharacter = null
		var closest_distance: float = INF

		for target in targets:
			var distance := global_position.distance_to(target.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_target = target

		if closest_target:
			current_target = closest_target
			print_debug("Zombie acquired new target: %s" % current_target.name)

	if current_target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	look_at(current_target.global_position)

	var direction: Vector2 = (current_target.global_position - global_position).normalized()
	velocity = direction * 100.0
	move_and_slide()
