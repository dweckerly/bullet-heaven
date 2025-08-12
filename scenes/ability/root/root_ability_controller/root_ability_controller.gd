extends Node

const MAX_RANGE: float = 60.0

@export var root_ability: PackedScene
@export var level_modifiers: LevelModifier

@onready var timer: Timer = $Timer

var id: String = "root"
var level: int  = 1
var base_damage: float = 10
var additional_damage_percent: float = 1.0
var base_wait_time: float

func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	for i in level_modifiers.LEVEL_MODS[level][Modifiers.AMOUNT]:
		var spawn_position = Utility.get_random_point_in_radius(player.global_position, MAX_RANGE)
		var root_instance = root_ability.instantiate() as Node2D
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(root_instance)
		root_instance.hitbox_component.damage = base_damage * \
				(1 + level_modifiers.LEVEL_MODS[level][Modifiers.DAMAGE]\
				+ player.character.modifiers[Modifiers.DAMAGE]['value'])
		root_instance.global_position = spawn_position
		await get_tree().create_timer(0.3).timeout

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = level_modifiers.LEVEL_MODS[level][Modifiers.COOLDOWN]
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()
