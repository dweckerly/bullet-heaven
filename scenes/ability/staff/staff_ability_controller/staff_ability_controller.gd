extends Node

@export var staff_ability: PackedScene

@onready var timer: Timer = $Timer

var id: String = "staff"
var level: int  = 1
var base_damage: float = 10.0
var additional_damage_percent: float = 1.0
var base_wait_time: float

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	if player == null:
		return
	var staff_instance = staff_ability.instantiate() as StaffAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(staff_instance)
	staff_instance.set_missile_count(level)
	staff_instance.set_missle_damage(base_damage * \
		(1 + player.character.modifiers[Modifiers.DAMAGE]['value']))

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = player.character.modifiers[Modifiers.COOLDOWN]['value']
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()
