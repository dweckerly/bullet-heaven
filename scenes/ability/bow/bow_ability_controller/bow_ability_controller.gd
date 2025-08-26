extends Node

@export var bow_ability_scene: PackedScene
@export var level_modifier: LevelModifier

@onready var timer: Timer = $Timer


var id = "bow"
var level: int = 1
var base_damage = 10
#var knockback_strength = 100
var additional_damage_percent = 1
var last_movement_vector = Vector2.RIGHT
var direction = Vector2.RIGHT.angle()
var player
var base_wait_time: float

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	base_wait_time = timer.wait_time * player.character.modifiers[Modifiers.COOLDOWN]['value']
	player = get_tree().get_first_node_in_group("player") as Player
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _process(delta: float) -> void:
	face_player_movement_direction()


func on_timer_timeout() -> void:
	if player == null:
		return
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
		
	var base_angle = (180 / (level + 1)) - 90
	for i in level:
		var adjusted_angle = base_angle + (180 / (level + 1)) * i
		var bow_instance = bow_ability_scene.instantiate() as BowAbility
		foreground.add_child(bow_instance)
		bow_instance.global_position = player.global_position
		bow_instance.rotation = direction + deg_to_rad(adjusted_angle)
		bow_instance.hitbox_component.damage = base_damage * \
			(1 + player.character.modifiers[Modifiers.DAMAGE]['value'])
		bow_instance.speed = bow_instance.speed * (1 + player.character.modifiers[Modifiers.SPEED]['value'])
		#bow_instance.hitbox_component.knockback = knockback_strength


func face_player_movement_direction() -> void:
	var movement_vector = player.get_movement_vector().normalized()
	if movement_vector.x != 0 || movement_vector.y != 0:
		last_movement_vector = movement_vector
	direction = last_movement_vector.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == id:
		level = current_upgrades[id]["quantity"]
		var percent_reduction = player.character.modifiers[Modifiers.COOLDOWN]['value']
		timer.wait_time = max(base_wait_time - (base_wait_time * percent_reduction), 0.1)
		timer.start()
	
