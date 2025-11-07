@tool
class_name PolygonColliders
extends EditorScript

func _run() -> void:
    var polygons := collect_polygons(get_scene())

    print("Found %d polygons." % polygons.size())

    for polygon in polygons:
        if polygon.name.ends_with("_wall") or polygon.name.ends_with("_half"):
            var is_half := polygon.name.ends_with("_half")

            var child := polygon.get_child(0)
            var static_object: StaticBody2D
            if child is StaticBody2D:
                static_object = child
            elif child is Node:
                push_error("{} already has a child node.".format(polygon.name))
                continue
            else:
                static_object = StaticBody2D.new()
                polygon.add_child(static_object)
                static_object.owner = polygon.owner  # Ensure the collider is saved with the scene

            var child_child := static_object.get_child(0)
            var collision_shape: CollisionPolygon2D
            if child_child is CollisionPolygon2D:
                collision_shape = child_child
            else:
                collision_shape = CollisionPolygon2D.new()
                static_object.add_child(collision_shape)
                collision_shape.owner = polygon.owner  # Ensure the collider is saved with the scene

            static_object.name = "HalfWallCollider" if is_half else "WallCollider"
            collision_shape.name = "CollisionShape"

            collision_shape.polygon = polygon.polygon
            collision_shape.position = Vector2.ZERO
            collision_shape.rotation = 0.0
            collision_shape.scale = Vector2.ONE

            collision_shape.visible = false

            static_object.collision_layer = 0
            static_object.set_collision_layer_value(LayerNames.P_SOLID_HALF if is_half else LayerNames.P_SOLID, true)

func collect_polygons(root: Node2D) -> Array[Polygon2D]:
    var polygons: Array[Polygon2D] = []
    if root is Polygon2D:
        polygons.append(root)
    for child in root.get_children():
        # if child.owner != root.owner: # prevent editing sub scenes
        #     continue
        if child is Polygon2D:
            polygons.append(child)
        elif child is Node2D:
            polygons += collect_polygons(child)
    return polygons