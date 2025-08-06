extends Node

const MAX_RANGE: float = 100.0

@export var sword_ability: PackedScene
@export var level_modifier: LevelModifier

@onready var timer: Timer = $Timer

var id: String = "sword"
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
	
	var target_enemies = Utility.get_closest_enemies_within_range(player, MAX_RANGE)
	var enemy_count = target_enemies.size()
	if target_enemies.size() > 0:
		for i in level_modifier.LEVEL_MODS[level][Modifiers.AMOUNT]:
			var target_enemy = target_enemies[i % enemy_count]
			var sword_instance = sword_ability.instantiate() as SwordAbility
			var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
			foreground_layer.add_child(sword_instance)
			sword_instance.hitbox_component.damage = base_damage * (1 + level_modifier.LEVEL_MODS[level][Modifiers.DAMAGE])
			var sword_spawn_position = player.global_position
			if target_enemy != null:
					sword_spawn_position = target_enemy.global_position
			sword_instance.global_position = sword_spawn_position
			sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
			var enemy_direction = sword_spawn_position - player.global_position
			sword_instance.rotation = enemy_direction.angle()
			await get_tree().create_timer(0.3).timeout
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = level_modifier.LEVEL_MODS[level][Modifiers.COOLDOWN]
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()
	#elif upgrade.id == "sword_damage":
		#additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)
