extends Node

var player: Player

func set_player(_player: Player) -> void:
	player = _player

func get_player() -> Player:
	return player

func get_player_global_pos() -> Vector2:
	return (player as Node2D).global_position

func get_player_modifiers() -> Dictionary:
	return player.character.modifiers

func get_player_modifier_value(mod: String) -> float:
	return player.character.modifiers[mod]['value']
