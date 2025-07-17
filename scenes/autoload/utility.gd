extends Node


func get_closest_enemy_within_range(source: Node2D, range: float) -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(
		func(enemy: Node2D): 
			return enemy.global_position.distance_squared_to(source.global_position) < pow(range, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(
		func(a: Node2D, b: Node2D): 
			var a_distance = a.global_position.distance_squared_to(source.global_position)
			var b_distance = b.global_position.distance_squared_to(source.global_position)
			return a_distance < b_distance
	)
	return enemies[0]
