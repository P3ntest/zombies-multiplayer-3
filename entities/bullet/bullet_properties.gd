class_name BulletProperties

var stopping_power: float = 1.0;

var base_damage: int = 10;

var enable_damage_dropoff: bool = false;
var damage_dropoff_start: float = 500.0;

var max_distance: float = 2000.0;

var penetration_left: float = 2.0;
var distance_travelled: float = 0.0;

func get_damage() -> int:
    if not enable_damage_dropoff:
        return base_damage

    # TODO: Implement damage dropoff calculation
    return base_damage

func get_stopping_power() -> float:
    return stopping_power

func remaining_distance() -> float:
    return max_distance - distance_travelled