extends Node

const MAX_RANGE: float = 60.0

@export var root_ability: PackedScene

@onready var timer: Timer = $Timer

var id: String = "root"
var level: int  = 1
var base_damage: float = 10
var additional_damage_percent: float = 1.0
var base_wait_time: float
var scale_mod: float = 1.0


func _ready() -> void:
	base_wait_time = timer.wait_time - (timer.wait_time * Global.get_player_modifier_value(Modifiers.COOLDOWN))
	timer.timeout.connect(on_timer_timeout)
	scale_mod = scale_mod * (1 + Global.get_player_modifier_value(Modifiers.SIZE))
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	for i in level:
		var spawn_position = Utility.get_random_point_in_radius(Global.get_player_global_pos(), MAX_RANGE)
		var root_instance = root_ability.instantiate() as Node2D
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(root_instance)
		root_instance.hitbox_component.damage = base_damage * \
				(1 + Global.get_player_modifier_value(Modifiers.DAMAGE))
		root_instance.global_position = spawn_position
		root_instance.set_scale_mod(scale_mod)
		await get_tree().create_timer(0.3).timeout

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	scale_mod = scale_mod * (1 + Global.get_player_modifier_value(Modifiers.SIZE))
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = Global.get_player_modifier_value(Modifiers.COOLDOWN)
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()
