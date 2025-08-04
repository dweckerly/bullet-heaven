extends Node2D
class_name StaffAbility

@export var missile: PackedScene

var MAX_RANGE: int = 400
var player

var missiles_count: int = 1

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	await $AnimationPlayer.animation_finished
	on_animation_finished()

func _process(delta: float) -> void:
	if player == null:
		return
	global_position = player.global_position + Vector2(0, -32)

func set_missile_count(amount: int) -> void:
	missiles_count = amount

func on_animation_finished() -> void:
	if player == null:
		return
		
	var target_enemies = Utility.get_closest_enemies_within_range(player, MAX_RANGE)
	var enemy_count = target_enemies.size()
	if enemy_count > 0:
		for i in missiles_count:
			var random_index = randi_range(0, (enemy_count - 1))
			var target_enemy = target_enemies[random_index]
			var missle_instance = missile.instantiate() as Missile
			var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
			foreground_layer.add_child(missle_instance)
			missle_instance.global_position = self.global_position
			var missle_direction = (target_enemy.global_position - self.global_position)
			missle_instance.rotation = missle_direction.angle()
	queue_free()
