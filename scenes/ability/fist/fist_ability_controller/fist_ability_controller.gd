extends Node

const MAX_RANGE: float = 60.0

@export var fist_ability: Array[PackedScene]
@export var level_modifier: LevelModifier

@onready var timer: Timer = $Timer

var id: String = "fist"
var level: int = 1
var base_damage = 10
var knockback_strength = 100
var additional_damage_percent = 1
var last_movement_vector = Vector2.RIGHT
var direction = Vector2.RIGHT.angle()

var base_wait_time: float


func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_enemies = Utility.get_closest_enemies_within_range(player, MAX_RANGE)
	var enemy_count = target_enemies.size() 
	var moves = fist_ability.size()
	for i in level_modifier.LEVEL_MODS[level][Modifiers.AMOUNT]:
		var fist_instance = fist_ability[i % moves].instantiate() as FistAbility
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(fist_instance)
		fist_instance.hitbox_component.damage = base_damage * additional_damage_percent
		fist_instance.hitbox_component.knockback = knockback_strength
		var fist_direction = player.global_position
		
		var target_enemy = null
		if enemy_count > 0:
			target_enemy = target_enemies[i % enemy_count]
		if target_enemy == null:
			fist_instance.global_position = player.global_position
		else:
			fist_instance.global_position = target_enemy.global_position
			fist_direction = target_enemy.global_position - fist_instance.global_position
		fist_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
		
		fist_instance.rotation = fist_direction.angle()
		
		await get_tree().create_timer(0.3).timeout

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = level_modifier.LEVEL_MODS[level][Modifiers.COOLDOWN]
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()
