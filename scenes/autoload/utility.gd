extends Node

func get_random_point_in_radius(center: Vector2, max_radius: float) -> Vector2:
	var angle = randf() * 2 * PI
	var distance = sqrt(randf()) * max_radius
	var offset = Vector2(cos(angle) * distance, sin(angle) * distance)
	return center + offset

func random_point_on_circle_edge(center: Vector2, radius: float) -> Vector2:
	var angle = randf() * 2 * PI
	return center + Vector2(cos(angle), sin(angle)) * radius

func get_random_top_position_within_view(player_pos: Vector2) -> Vector2:
	#640 360
	var top_y = player_pos.y - 180 - 16 
	var random_x = randf_range(player_pos.x - 320, player_pos.x + 320)
	return Vector2(random_x, top_y)


func get_closest_enemies_within_range(source: Node2D, max_distance: float) -> Array[Node]:
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(
		func(enemy: Node2D): 
			return enemy.global_position.distance_squared_to(source.global_position) < pow(max_distance, 2)
	)
	if enemies.size() == 0:
		return []
	
	enemies.sort_custom(
		func(a: Node2D, b: Node2D): 
			var a_distance = a.global_position.distance_squared_to(source.global_position)
			var b_distance = b.global_position.distance_squared_to(source.global_position)
			return a_distance < b_distance
	)
	return enemies
