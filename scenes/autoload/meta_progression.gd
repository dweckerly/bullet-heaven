extends Node

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}


func _ready() -> void:
	GameEvents.xp_gem_collected.connect(on_xp_collected)
	

func add_meta_upgrade(upgrade: MetaUpgrade) -> void:
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1


func on_xp_collected(number: float) -> void:
	save_data["meta_upgrade_currency"] += number
