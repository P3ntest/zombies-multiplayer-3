extends Node2D

## List of FABRIK constraints to apply rotation adjustments to
@export var fabrik_constraints: Array[SkeletonModification2DFABRIK] = []

# Initial vectors, that get rotated each frame to adjust for player rotation
var initial_vectors: Array[Vector2] = []

func capture_initial_vectors():
    for constraint in fabrik_constraints:
        for j in range(1, constraint.fabrik_data_chain_length):
            initial_vectors.append(
                constraint.get_fabrik_joint_magnet_position(j))
                
func apply_rotations(adjustment_rotation: float):
    var i: int = 0

    for constraint in fabrik_constraints:
        for j in range(1, constraint.fabrik_data_chain_length):
            var initial_vector: Vector2 = initial_vectors[i]
            i += 1
            var rotated_vector: Vector2 = initial_vector.rotated(adjustment_rotation) * 100

            constraint.set_fabrik_joint_magnet_position(
                j, 
                rotated_vector)

func _ready():
    capture_initial_vectors()

func _process(_delta):
    apply_rotations(global_rotation)

    