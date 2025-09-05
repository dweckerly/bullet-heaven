extends Node2D
class_name StaffAbility

@export var missile: PackedScene

var MAX_RANGE: int = 400
var damage: float = 10
var missiles_count: int = 1

func _ready() -> void:
	await $AnimationPlayer.animation_finished
	on_animation_finished()

func _process(delta: float) -> void:
	global_position = Global.get_player_global_pos() + Vector2(0, -32)

func set_missile_count(amount: int) -> void:
	missiles_count = amount

func set_missle_damage(amount: float) -> void:
	damage = amount

func on_animation_finished() -> void:
	var target_enemies = Utility.get_closest_enemies_within_range(Global.get_player(), MAX_RANGE)
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
			missle_instance.hitbox_component.damage = damage
	queue_free()
