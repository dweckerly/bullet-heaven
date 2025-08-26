extends Node2D
class_name SwordAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

var scale_mod: float = 1.0

func _ready() -> void:
	sprite_2d.scale *= scale_mod
