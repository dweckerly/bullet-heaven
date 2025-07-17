extends Node

const MAX_RANGE: float = 60.0

@export var fist_ability: PackedScene
@onready var timer: Timer = $Timer

var base_damage = 3
var knockback_strength = 100
var additional_damage_percent = 1
var last_movement_vector = Vector2.RIGHT
var direction = Vector2.RIGHT.angle()


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	
	
func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_enemy = Utility.get_closest_enemy_within_range(player, MAX_RANGE)
	
	var fist_instance = fist_ability.instantiate() as FistAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(fist_instance)
	fist_instance.hitbox_component.damage = base_damage * additional_damage_percent
	fist_instance.hitbox_component.knockback = knockback_strength
	
	fist_instance.global_position = target_enemy.global_position
	fist_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = target_enemy.global_position - fist_instance.global_position
	fist_instance.rotation = enemy_direction.angle()
