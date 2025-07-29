extends Node

const BASE_WEIGHT: int = 10
const UPGRADE_CHOICES: int = 2

@export var xp_manager: XPManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var axe = preload("res://resources/upgrades/axe.tres")
var bow = preload("res://resources/upgrades/bow.tres")
var sword = preload("res://resources/upgrades/sword.tres")
var fist = preload("res://resources/upgrades/fist.tres")

#var player_speed = preload("res://resources/upgrades/player_speed.tres")


func _ready() -> void:
	upgrade_pool.add_item(axe, BASE_WEIGHT)
	upgrade_pool.add_item(bow, BASE_WEIGHT)
	upgrade_pool.add_item(sword, BASE_WEIGHT)
	upgrade_pool.add_item(fist, BASE_WEIGHT)
	#upgrade_pool.add_item(player_speed, BASE_WEIGHT)
	
	xp_manager.level_up.connect(on_level_up)
	var player_class = GameEvents.get_selected_character()
	apply_upgrade(player_class.starting_ability)
	


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade) -> void:
	var current_weight = upgrade_pool.get_weight(chosen_upgrade.id)
	if current_weight != 0:
		upgrade_pool.update_weight(chosen_upgrade.id, current_weight + BASE_WEIGHT / 5)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades() -> Array[Dictionary]:
	var chosen_upgrades: Array[Dictionary] = []
	var exclude_upgrades: Array = []
	for i in UPGRADE_CHOICES:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(exclude_upgrades)
		exclude_upgrades.append(chosen_upgrade)
		if current_upgrades.has(chosen_upgrade.id):
			chosen_upgrades.append({"upgrade": chosen_upgrade, "level": current_upgrades[chosen_upgrade.id]["quantity"] + 1})
		else:
			chosen_upgrades.append({"upgrade": chosen_upgrade, "level": 1})
	
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)


func on_level_up(current_level: int) -> void:
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as AbilityUpgradeScreen
	add_child(upgrade_screen_instance)
	var chosen_upgrades: Array[Dictionary] = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
