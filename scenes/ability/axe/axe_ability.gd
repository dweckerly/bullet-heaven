extends Node2D
class_name AxeAbility

const MAX_RADIUS: float  = 100
const MAX_ROTATIONS: int = 2

@onready var hitbox_component = $HitboxComponent

var base_rotation: Vector2 = Vector2.RIGHT

func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)

func tween_method(rotations: float) -> void:
	var percent = rotations / MAX_ROTATIONS
	var current_radius = percent * MAX_RADIUS
	var currennt_direction = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = player.global_position + (currennt_direction * current_radius)
