class_name PlayerVisualWeaponAnimationHandler
extends Node

@export var weapon_manager: PlayerVisualWeaponManager
@export var anim_player: AnimationPlayer

func _play_idle() -> void:
    var idle = weapon_manager._equipped_weapon.idle_animation
    print("Playing idle animation: %s" % idle)
    anim_player.play(idle)

func _play_shoot() -> void:
    var shoot = weapon_manager._equipped_weapon.shoot_animation
    print("Playing shoot animation: %s" % shoot)
    if anim_player.is_playing() and anim_player.current_animation == shoot:
        anim_player.seek(0.0)
    else:
        anim_player.play(shoot)

func _ready():
    weapon_manager.weapon_changed.connect(_play_idle)
    _play_idle()

    anim_player.animation_finished.connect(
        _play_idle
    )