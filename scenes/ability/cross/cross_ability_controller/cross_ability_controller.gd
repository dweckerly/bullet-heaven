extends Node

@export var cross_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var id = "cross"
var level: int = 1
var base_damage: int = 20
var additional_damage_percent: float = 1.0
var cross_scale: float = 1.0
var axe_duration: float = 1.0
var base_wait_time: float

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	base_wait_time = timer.wait_time - (timer.wait_time * Global.get_player_modifier_value(Modifiers.COOLDOWN))
	cross_scale = cross_scale * (1 +  Global.get_player_modifier_value(Modifiers.SIZE))
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func on_timer_timeout() -> void:
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	for i in level:
		var cross_instance = cross_ability_scene.instantiate() as CrossAbility
		cross_instance.scale_mod = cross_scale
		foreground.add_child(cross_instance)
		cross_instance.global_position = Global.get_player_global_pos()
		cross_instance.hitbox_component.damage = base_damage * \
			(1 + Global.get_player_modifier_value(Modifiers.DAMAGE))
		

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		cross_scale = cross_scale * (1 +  Global.get_player_modifier_value(Modifiers.SIZE))
		var percent_reduction = Global.get_player_modifier_value(Modifiers.COOLDOWN)
		timer.wait_time = max(base_wait_time - (base_wait_time * percent_reduction), 0.1)
		timer.start()
