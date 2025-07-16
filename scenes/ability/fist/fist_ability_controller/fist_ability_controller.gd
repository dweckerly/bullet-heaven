extends Node

const MAX_RANGE: float = 60.0

@export var fist_ability: PackedScene
@onready var timer: Timer = $Timer

var base_damage = 3
var knockback_strength = 100
var additional_damage_percent = 1
var last_movement_vector = Vector2.RIGHT
var direction = Vector2.RIGHT.angle()
var player


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	player = get_tree().get_first_node_in_group("player") as Player
	
	
func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(
		func(enemy: Node2D): 
			return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(
		func(a: Node2D, b: Node2D): 
			var a_distance = a.global_position.distance_squared_to(player.global_position)
			var b_distance = b.global_position.distance_squared_to(player.global_position)
			return a_distance < b_distance
	)
	
	var fist_instance = fist_ability.instantiate() as FistAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(fist_instance)
	fist_instance.hitbox_component.damage = base_damage * additional_damage_percent
	fist_instance.hitbox_component.knockback = knockback_strength
	
	fist_instance.global_position = enemies[0].global_position
	fist_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - fist_instance.global_position
	fist_instance.rotation = enemy_direction.angle()
