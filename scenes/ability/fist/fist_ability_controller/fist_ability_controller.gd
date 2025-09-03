extends Node

const MAX_RANGE: float = 60.0

@export var fist_ability: Array[PackedScene]

@onready var timer: Timer = $Timer

var id: String = "fist"
var level: int = 1
var base_damage = 10
var knockback_strength = 100
var additional_damage_percent = 1
var last_movement_vector = Vector2.RIGHT
var direction = Vector2.RIGHT.angle()

var base_wait_time: float
var player

func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var moves = fist_ability.size()
	for i in level:
		var fist_instance = fist_ability[i % moves].instantiate() as FistAbility
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(fist_instance)
		fist_instance.hitbox_component.damage = base_damage * additional_damage_percent
		fist_instance.hitbox_component.knockback = knockback_strength

		fist_instance.global_position = player.global_position
		fist_instance.rotation = face_player_movement_direction(player)
		
		await get_tree().create_timer(0.3).timeout

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = player.character.modifiers[Modifiers.COOLDOWN]['value']
		timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		timer.start()

func face_player_movement_direction(player: Node2D) -> float:
	var movement_vector = player.get_movement_vector().normalized()
	if movement_vector.x != 0 || movement_vector.y != 0:
		last_movement_vector = movement_vector
	return last_movement_vector.angle()
