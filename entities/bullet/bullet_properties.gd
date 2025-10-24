class_name BulletProperties

var max_distance: float = 2000.0;

var penetration_left: float = 2.0;
var distance_travelled: float = 0.0;

func remaining_distance() -> float:
    return max_distance - distance_travelled