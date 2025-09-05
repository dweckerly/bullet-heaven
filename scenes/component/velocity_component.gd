extends Node
class_name VelocityComponent

@export var max_speed: float = 40
@export var acceleration: float = 5

var velocity: Vector2 = Vector2.ZERO
var knockback: float = 0

func accelerate_to_player() -> void:
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	if Global.get_player() == null:
		return
	
	var direction = Vector2.ZERO
	if knockback > 0:
		direction = (owner_node2d.global_position - Global.get_player_global_pos()).normalized()
		knockback = lerp(knockback, 0.0, 0.5)
		if knockback < 0.001:
			knockback = 0
	else:
		direction = (Global.get_player_global_pos() - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2) -> void:
	var desired_velocity = Vector2.ZERO
	if knockback > 0:
		desired_velocity = direction * max_speed * knockback
	else:
		desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func decelerate() -> void:
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D) -> void:
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity


func receive_knockback(strength: float) -> void:
	if strength > 0:
		knockback = strength
