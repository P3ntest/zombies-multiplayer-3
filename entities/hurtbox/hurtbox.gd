class_name HurtBox
extends Area2D

func _ready():
    collision_layer = 0
    set_collision_layer_value(LayerNames.P_HURTBOX, true)

func bullet_hit(bullet: BulletProperties, hit_position: Vector2, bullet_direction: Vector2) -> BulletHit:
    var hit = BulletHit.new()
    hit.penetration_used = 1.0

    print_debug("HurtBox hit ouch")

    return hit