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

var duplicate_offset

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	base_wait_time = timer.wait_time - (timer.wait_time * Global.get_player_modifier_value(Modifiers.COOLDOWN))
	cross_scale = cross_scale * (1 +  Global.get_player_modifier_value(Modifiers.SIZE))
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func on_timer_timeout() -> void:
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var first_spawn_pos = Vector2.ZERO
	var spawn_pos = Vector2.ZERO
	for i in level:
		var cross_instance = cross_ability_scene.instantiate() as CrossAbility
		cross_instance.scale_mod = cross_scale
		foreground.add_child(cross_instance)
		if i == 0:
			first_spawn_pos = Global.get_player_global_pos()
			spawn_pos = first_spawn_pos
		else:
			spawn_pos = Utility.random_point_on_circle_edge(
				first_spawn_pos, 32.0 * cross_instance.scale_mod
			)
		cross_instance.global_position = spawn_pos
		cross_instance.hitbox_component.damage = base_damage * \
			(1 + Global.get_player_modifier_value(Modifiers.DAMAGE))
		await get_tree().create_timer(0.3).timeout
		

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		cross_scale = cross_scale * (1 +  Global.get_player_modifier_value(Modifiers.SIZE))
		var percent_reduction = Global.get_player_modifier_value(Modifiers.COOLDOWN)
		timer.wait_time = max(base_wait_time - (base_wait_time * percent_reduction), 0.1)
		timer.start()
