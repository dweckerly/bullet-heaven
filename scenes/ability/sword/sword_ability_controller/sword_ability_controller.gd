extends Node

const MAX_RANGE: float = 100.0

@export var sword_ability: PackedScene
@export var level_modifiers: LevelModifier

@onready var timer: Timer = $Timer

var id: String = "sword"
var level: int  = 1
var base_damage: float = 10
var additional_damage_percent: float = 1.0
var sword_scale: float = 1.0
var base_wait_time: float

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	base_wait_time = timer.wait_time - (timer.wait_time * player.character.modifiers[Modifiers.COOLDOWN]['value'])
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	if player == null:
		return
	var target_enemies = Utility.get_closest_enemies_within_range(player, MAX_RANGE)
	var enemy_count = target_enemies.size()
	if target_enemies.size() > 0:
		for i in level:
			var target_enemy = target_enemies[i % enemy_count]
			var sword_instance = sword_ability.instantiate() as SwordAbility
			var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
			foreground_layer.add_child(sword_instance)
			sword_instance.hitbox_component.damage = base_damage * \
				(1 + player.character.modifiers[Modifiers.DAMAGE]['value'])
			var sword_spawn_position = player.global_position
			if target_enemy != null:
					sword_spawn_position = target_enemy.global_position
			sword_instance.global_position = sword_spawn_position
			sword_instance.set_scale_mod(sword_scale)
			sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
			var enemy_direction = sword_spawn_position - player.global_position
			sword_instance.rotation = enemy_direction.angle()
			await get_tree().create_timer(0.3).timeout
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = player.character.modifiers[Modifiers.COOLDOWN]['value']
		sword_scale = sword_scale * (1 + player.character.modifiers[Modifiers.SIZE]['value'])
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()
