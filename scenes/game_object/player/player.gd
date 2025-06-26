extends CharacterBody2D

const PLAYER_SPEED = 50
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities

var number_colliding_bodies: int = 0

func _ready() -> void:
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	update_health_display()
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func _process(delta) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * PLAYER_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()

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

func on_body_entered(other_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(other_body: Node2D) -> void:
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func on_health_changed() -> void:
	update_health_display()
	

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if not ability_upgrade is Ability:
		return
	abilities.add_child((ability_upgrade as Ability).ability_controller_scene.instantiate())
	
