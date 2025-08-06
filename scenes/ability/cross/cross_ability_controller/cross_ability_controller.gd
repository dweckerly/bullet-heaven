extends Node

@export var cross_ability_scene: PackedScene
@export var level_modifiers: LevelModifier


var id = "cross"
var level: int = 1
var base_damage: int = 20
var additional_damage_percent: float = 1.0
var axe_count: int = 1
var axe_scale: float = 1.0
var axe_speed: float = 1.0
var axe_duration: float = 1.0
var axe_cooldown: float = 1.0


func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	var cross_instance = cross_ability_scene.instantiate() as CrossAbility
	#cross_instance.scale_mod = axe_scale
	foreground.add_child(cross_instance)
	cross_instance.global_position = player.global_position
	cross_instance.hitbox_component.damage = base_damage * (1 + level_modifiers.LEVEL_MODS[level][Modifiers.DAMAGE])
		
		

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		axe_scale = axe_scale * (1 + level_modifiers.LEVEL_MODS[level][Modifiers.SIZE])
