extends CharacterBody2D
class_name Player

const PLAYER_SPEED = 50
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var player_hurtbox: Area2D = $PlayerHurtbox
@onready var pickup_area: Area2D = $PickupArea

var number_colliding_bodies: int = 0
var base_speed: float = 0
var active_abilities: Array
var character: Character

func _ready() -> void:
	Global.set_player(self)
	player_hurtbox.body_entered.connect(on_body_entered)
	player_hurtbox.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	update_health_display()
	set_character(GameEvents.get_selected_character())
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	


func _process(delta) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage() -> void:
	if number_colliding_bodies == 0 || not damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display() -> void:
	health_bar.value = health_component.get_health_percent()


func set_character(_character: Character) -> void:
	if _character == null:
		return
	character = _character
	sprite_2d.texture = _character.sprite
	base_speed = velocity_component.max_speed * (1 + character.modifiers[Modifiers.MOVE_SPEED]['value'])
	velocity_component.max_speed = base_speed
	abilities.add_child(_character.starting_ability.ability_controller_scene.instantiate())


func on_body_entered(other_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D) -> void:
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func on_health_changed() -> void:
	GameEvents.emit_player_damaged()
	update_health_display()
	$RandomStreamPlayer2DComponent.play_random()
	
var equip_dict: Dictionary = {}

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if ability_upgrade is Ability:
		if current_upgrades[ability_upgrade.id]["quantity"] == 1:
			abilities.add_child((ability_upgrade as Ability).ability_controller_scene.instantiate())
	else:
		if ability_upgrade.id == "armor":
			character.modifiers[Modifiers.MAX_HEALTH]['value'] += 0.25
			var new_max_health = health_component.max_health * (1 + character.modifiers[Modifiers.MAX_HEALTH]['value'])
			var health_diff = new_max_health - health_component.max_health
			health_component.max_health = new_max_health
			health_component.current_health += health_diff
		if ability_upgrade.id == "fire_ring":
			character.modifiers[Modifiers.DAMAGE]['value'] += 0.25
		if ability_upgrade.id == "fox_amulet":
			character.modifiers[Modifiers.XP_GAIN]['value'] += 0.25
		if ability_upgrade.id == "nova_crown":
			character.modifiers[Modifiers.REACH]['value'] += 1
			pickup_area.scale *= (1 + character.modifiers[Modifiers.REACH]['value'])
		#velocity_component.max_speed = base_speed + \
		#(base_speed * current_upgrades["player_speed"]["quantity"] * 0.25)
