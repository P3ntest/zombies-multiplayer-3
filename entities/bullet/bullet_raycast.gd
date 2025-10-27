class_name BulletRaycast
extends RayCast2D

func trace_bullet(bullet: BulletProperties, from_position: Vector2, bullet_direction: Vector2) -> BulletReport:
	var end_position: Vector2 = from_position + bullet_direction.normalized() * bullet.max_distance

	var hits := _trace_bullet(bullet, from_position, bullet_direction, true)
	var report := BulletReport.new()
	report.hits = hits

	if hits.size() > 0 and bullet.penetration_left <= 0:
		var last_hit: BulletHit = hits[hits.size() - 1]
		report.final_position = last_hit.hit_position
	else:
		report.final_position = end_position

	return report

func _trace_bullet(bullet: BulletProperties, from_position: Vector2, bullet_direction: Vector2, first_trace: bool) -> Array[BulletHit]:
	global_position = from_position

	if first_trace:
		print_debug("Starting Bullet Trace")

		clear_exceptions()
		collision_mask = 0
		set_collision_mask_value(LayerNames.P_HURTBOX, true)
		set_collision_mask_value(LayerNames.P_SOLID, true)
		collide_with_areas = true
		collide_with_bodies = true

	print_debug("Tracing bullet from %s towards %s" % [from_position, bullet_direction])

	target_position = bullet_direction.normalized() * bullet.remaining_distance()

	force_update_transform()
	force_raycast_update()

	if not is_colliding():
		print_debug("No collision detected, no more hits.")
		return []

	var hit_position: Vector2 = get_collision_point()
	var hit_object: Object = get_collider()

	var hit: BulletHit

	print_debug("Bullet hit at %s with object %s" % [hit_position, hit_object])

	if hit_object is HurtBox:
		var hurtbox: HurtBox = hit_object as HurtBox
		hit = hurtbox.bullet_hit(bullet, hit_position, bullet_direction)

		add_exception(hurtbox)

	else:
		# TODO: get thickness and material of wall + calculate penetration
		hit = BulletHit.new()
		hit.penetration_used = bullet.penetration_left + 1 # assume walls stop all bullets for now

		add_exception(hit_object)

	assert(hit != null, "Hit should not be null, after processing collision")

	bullet.penetration_left -= hit.penetration_used
	bullet.distance_travelled += from_position.distance_to(hit_position)
	hit.hit_position = hit_position

	if bullet.penetration_left > 0 and bullet.remaining_distance() > 0:
		print_debug("Bullet can penetrate further, continuing trace.")
		var further_hits: Array[BulletHit] = _trace_bullet(bullet, hit_position, bullet_direction, false)

		var all_hits: Array[BulletHit] = further_hits
		all_hits.push_front(hit)

		return all_hits
	else:
		print_debug("Bullet cannot penetrate further or has reached max distance.")
		return [hit]
