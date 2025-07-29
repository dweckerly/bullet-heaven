extends Node2D
class_name AxeAbility

const MAX_RADIUS: float  = 100
const MAX_ROTATIONS: int = 2

@onready var hitbox_component = $HitboxComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

var base_rotation: Vector2 = Vector2.RIGHT

var scale_mod: float = 1.0

func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_method, 0.0, 2.0, 3)
	tween.tween_property(sprite_2d, "scale", Vector2(scale_mod, scale_mod), .1)
	tween.chain()
	tween.tween_callback(queue_free)
	

func tween_method(rotations: float) -> void:
	
	var percent = rotations / MAX_ROTATIONS
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)
