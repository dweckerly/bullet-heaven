extends Node
class_name UpgradeManager

const BASE_WEIGHT: int = 10
const UPGRADE_CHOICES: int = 2

@export var xp_manager: XPManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var weapon_dict: Dictionary = {
	"orc" : preload("res://resources/upgrades/axe.tres"),
	"archer" : preload("res://resources/upgrades/bow.tres"),
	"priest" : preload("res://resources/upgrades/cross.tres"),
	"brawler" : preload("res://resources/upgrades/fist.tres"),
	"druid" : preload("res://resources/upgrades/root.tres"),
	"fighter" : preload("res://resources/upgrades/sword.tres"),
	"wizard" : preload("res://resources/upgrades/staff.tres") 
}

var equipment_dict: Dictionary = {
	"armor": preload("res://resources/upgrades/armor.tres"),
	"fire_ring" : preload("res://resources/upgrades/fire_ring.tres"),
	"fox_amulet" : preload("res://resources/upgrades/fox_amulet.tres"),
	"nova_crown" : preload("res://resources/upgrades/nova_crown.tres")
}

func _ready() -> void:
	for key in MetaProgression.save_data["characters"]:
		if not MetaProgression.save_data["characters"][key]["locked"]:
			if key == 'priest':
				upgrade_pool.add_item(weapon_dict[key], 1000)
			else:
				upgrade_pool.add_item(weapon_dict[key], BASE_WEIGHT)
	
	for key in equipment_dict:
		if not MetaProgression.save_data["equipment"][key]["locked"]:
			upgrade_pool.add_item(equipment_dict[key], BASE_WEIGHT)
	
	xp_manager.level_up.connect(on_level_up)
	var player_class = GameEvents.get_selected_character()
	if player_class != null:
		apply_upgrade(player_class.starting_ability)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade) -> void:
	var current_weight = upgrade_pool.get_weight(chosen_upgrade.id)
	if current_weight != 0:
		upgrade_pool.update_weight(chosen_upgrade.id, current_weight + BASE_WEIGHT / 5.0)


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
