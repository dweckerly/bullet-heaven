extends Area2D

@export var enemy: PackedScene
@export var entities_layer: Node2D

@export var one_shot: bool = true

var spawn_count: int = 0

func _on_body_entered(body: Node2D) -> void:
	if one_shot and spawn_count > 0:
		return
	var enemy_instance = enemy.instantiate() as Node2D
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = global_position
	spawn_count += 1
