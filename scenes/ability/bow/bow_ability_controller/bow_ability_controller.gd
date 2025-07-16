extends Node

@export var bow_ability_scene: PackedScene

var base_damage = 10
var additional_damage_percent = 1
var last_movement_vector = Vector2.RIGHT
var direction = Vector2.RIGHT.angle()
var player

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	player = get_tree().get_first_node_in_group("player") as Player


func _process(delta: float) -> void:
	direction = face_player_movement_direction()

func on_timer_timeout() -> void:
	if player == null:
		return
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var bow_instance = bow_ability_scene.instantiate() as BowAbility
	foreground.add_child(bow_instance)
	bow_instance.global_position = player.global_position
	bow_instance.rotation = direction
	bow_instance.hitbox_component.damage = base_damage * additional_damage_percent


func face_player_movement_direction() -> float:
	var movement_vector = player.get_movement_vector().normalized()
	var direction = Vector2.ZERO
	if movement_vector.x != 0 || movement_vector.y != 0:
		last_movement_vector = movement_vector
	direction = last_movement_vector.angle()
	return direction
