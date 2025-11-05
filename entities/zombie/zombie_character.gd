extends CharacterBody2D

@export var health_component: HealthComponent
@export var speed_controller: SpeedController

@export var ti: TickInterpolator

@export var attack_cooldown: float = 1.0
@export var attack_range: float = 200.0
var current_attack_cooldown: float = 0

func _ready() -> void:
	# health_component.health_depleted.connect(_on_health_depleted)

	if multiplayer.is_server():
		ti.queue_free()

# func _on_health_depleted() -> void:
# 	print("Queuing zombie for deletion on on peer id %d" % multiplayer.get_unique_id())
# 	queue_free()

var current_target: PlayerCharacter = null

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return

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

	if current_target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	current_attack_cooldown -= delta

	look_at(current_target.global_position)

	if current_attack_cooldown <= 0.0:
		var direction: Vector2 = (current_target.global_position - global_position).normalized()
		velocity = direction * speed_controller.get_current_speed()
		move_and_slide()

	if global_position.distance_to(current_target.global_position) <= attack_range:
		if current_attack_cooldown <= 0.0:
			current_target.health_component.damage(10, 1.0)
			current_attack_cooldown = attack_cooldown
