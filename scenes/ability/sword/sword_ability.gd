extends Node2D
class_name SwordAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $HitboxComponent/CollisionShape2D

func set_scale_mod(scale_mod: float) -> void:
	sprite_2d.scale *= scale_mod
	collision_shape_2d.scale *= scale_mod
