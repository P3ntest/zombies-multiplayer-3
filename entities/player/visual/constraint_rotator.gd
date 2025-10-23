extends Node2D

# List of FABRIK constraints to apply rotation adjustments to
var fabrik_constraints: Array[SkeletonModification2DFABRIK] = []

# Initial vectors, that get rotated each frame to adjust for player rotation
var initial_vectors: Array[Vector2] = []

@onready var skeleton: Skeleton2D = get_parent() as Skeleton2D

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
            var rotated_vector: Vector2 = initial_vector.rotated(adjustment_rotation)

            constraint.set_fabrik_joint_magnet_position(
                j, 
                rotated_vector)

func capture_constraints():
    var stack := skeleton.get_modification_stack()
    for index in range(stack.modification_count):
        var modification := stack.get_modification(index)
        if modification is SkeletonModification2DFABRIK:
            fabrik_constraints.append(modification)

func _ready():
    capture_constraints()
    capture_initial_vectors()

func _process(_delta):
    apply_rotations(global_rotation)

    