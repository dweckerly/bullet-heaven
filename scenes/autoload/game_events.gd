extends Node

signal xp_gem_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged
signal character_selected(character: Character)

var selected_character: Character

func emit_xp_gem_collected(number: float) -> void:
	xp_gem_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_player_damaged() -> void:
	player_damaged.emit()

func get_selected_character() -> Character:
	return selected_character

func emit_character_selected(character: Character) -> void:
	selected_character = character
	character_selected.emit(character)
