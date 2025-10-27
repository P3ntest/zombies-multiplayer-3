class_name PlayerVisualWeaponAnimationHandler
extends Node

@export var weapon_manager: PlayerVisualWeaponManager
@export var anim_player: AnimationPlayer

func _play_idle() -> void:
    var idle = weapon_manager._equipped_weapon.idle_animation
    anim_player.speed_scale = 1.0
    if anim_player.is_playing() and anim_player.current_animation == idle:
        return
    anim_player.play(idle)

func _play_or_restart(animation_name: String) -> void:
    if anim_player.is_playing() and anim_player.current_animation == animation_name:
        anim_player.seek(0.0)
    else:
        anim_player.play(animation_name)

func _play_shoot() -> void:
    var shoot = weapon_manager._equipped_weapon.shoot_animation
    _play_or_restart(shoot)

func _ready():
    weapon_manager.weapon_changed.connect(_play_idle)
    _play_idle()

    anim_player.animation_finished.connect(func(_anim: String) -> void:
        _play_idle()
    )
