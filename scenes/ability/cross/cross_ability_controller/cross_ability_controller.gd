extends Node

@export var cross_ability_scene: PackedScene
@export var level_modifiers: LevelModifier

@onready var timer: Timer = $Timer

var id = "cross"
var level: int = 1
var base_damage: int = 20
var additional_damage_percent: float = 1.0
var cross_scale: float = 1.0
var axe_duration: float = 1.0
var base_wait_time: float
var player

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	base_wait_time = timer.wait_time - (timer.wait_time * player.character.modifiers[Modifiers.COOLDOWN]['value'])
	player = get_tree().get_first_node_in_group("player") as Player
	cross_scale = cross_scale * (1 +  player.character.modifiers[Modifiers.SIZE]['value'])
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func on_timer_timeout() -> void:
	if player == null:
		return
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	for i in level:
		var cross_instance = cross_ability_scene.instantiate() as CrossAbility
		cross_instance.scale_mod = cross_scale
		foreground.add_child(cross_instance)
		cross_instance.global_position = player.global_position
		cross_instance.hitbox_component.damage = base_damage * \
			(1 + player.character.modifiers[Modifiers.DAMAGE]['value'])
		

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		cross_scale = cross_scale * (1 +  player.character.modifiers[Modifiers.SIZE]['value'])
		var percent_reduction = player.character.modifiers[Modifiers.COOLDOWN]['value']
		timer.wait_time = max(base_wait_time - (base_wait_time * percent_reduction), 0.1)
		timer.start()
