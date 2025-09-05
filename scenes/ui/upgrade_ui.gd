extends CanvasLayer

@export var upgrade_manager: UpgradeManager
@export var upgrade_tag: PackedScene

@onready var tag_container: VBoxContainer = $MarginContainer/TagContainer

func _ready() -> void:
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	var children = tag_container.get_children() 
	for child in children:
		child.queue_free()
		
	for key in upgrade_manager.current_upgrades:
		var tag = upgrade_tag.instantiate()
		tag_container.add_child(tag)
		tag.set_tag_props(upgrade_manager.current_upgrades[key]['resource'].image,\
			upgrade_manager.current_upgrades[key]['quantity'])
		
