extends Node

@export var bow_ability_scene: PackedScene

var base_damage = 10
var additional_damage_percent = 1

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	print("shoot arrow")
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var bow_instance = bow_ability_scene.instantiate() as BowAbility
	foreground.add_child(bow_instance)
	bow_instance.global_position = player.global_position
	face_player_movement_direction(bow_instance, player)
	bow_instance.hitbox_component.damage = base_damage * additional_damage_percent


func face_player_movement_direction(bow_instance: Node, player: Player) -> void:
	var movement_vector = player.get_movement_vector().normalized()
	var direction = Vector2.ZERO
	if movement_vector.x == 0 && movement_vector.y == 0:
		var move_sign = player.get_move_sign()
		if move_sign < 0:
			direction = Vector2.LEFT
		else:
			direction = Vector2.RIGHT
	else:
		direction = movement_vector.angle()
	bow_instance.rotation = direction
