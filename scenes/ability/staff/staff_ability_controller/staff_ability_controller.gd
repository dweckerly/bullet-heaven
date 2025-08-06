extends Node

@export var staff_ability: PackedScene
@export var level_modifiers: LevelModifier

@onready var timer: Timer = $Timer

var id: String = "staff"
var level: int  = 1
var base_damage: float = 10.0
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
	var staff_instance = staff_ability.instantiate() as StaffAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(staff_instance)
	staff_instance.set_missile_count(level_modifiers.LEVEL_MODS[level][Modifiers.AMOUNT])
	staff_instance.set_missle_damage(base_damage * \
		(1 + level_modifiers.LEVEL_MODS[level][Modifiers.DAMAGE] \
		+ player.character.modifiers[Modifiers.DAMAGE]['value']))

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = level_modifiers.LEVEL_MODS[level][Modifiers.COOLDOWN]
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()
