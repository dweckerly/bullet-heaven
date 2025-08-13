extends CharacterBody2D

enum State {
	DESCENDING,
	ASCENDING,
	IDLE
}

@export var descent_speed: float = 50.0
@export var ascent_speed: float = 100.0
@export var max_descent_distance: float = 300.0
@export var web_thickness: float = 1.0

@onready var visuals: Node2D = $Visuals
@onready var velocity_component: VelocityComponent = $VelocityComponent 
@onready var web_line: Line2D = $WebLine
@onready var web_sprite: Sprite2D = $Visuals/WebSprite

var current_state: State = State.DESCENDING
var start_position: Vector2
var target_descent_y: float
var web_anchor_point: Vector2
var time_elapsed: float = 0.0


func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)
	web_sprite.global_position = web_anchor_point
	start_position = global_position
	web_anchor_point = start_position
	# Set random descent target
	target_descent_y = start_position.y + randf_range(150.0, max_descent_distance)
	# Setup web line
	setup_web_line()
	
	current_state = State.DESCENDING


func _physics_process(delta: float) -> void:
	#velocity_component.accelerate_to_player()
	#velocity_component.move(self)
	match current_state:
		State.DESCENDING:
			handle_descending()
		State.ASCENDING:
			handle_ascending()
		State.IDLE:
			handle_idle()
	
	# Update web line
	update_web_line()
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func setup_web_line():
	web_line.width = web_thickness
	web_line.default_color = Color.WHITE
	web_line.add_point(Vector2.ZERO)  # Relative to spider position
	web_line.add_point(Vector2.ZERO)  # Will be updated each frame


func handle_descending():
	# Move down
	velocity.y = descent_speed
	move_and_slide()
	
	# Check if reached target depth
	if global_position.y >= target_descent_y:
		hold_position()


func handle_ascending():
	# Move up
	velocity.y = -ascent_speed
	move_and_slide()
	# Check if reached starting height
	if global_position.y <= start_position.y:
		queue_free()  # Remove spider when it reaches the top


func handle_idle():
	# Optional state for hanging at bottom
	velocity.y = 0
	move_and_slide()


func update_web_line():
	if web_line.get_point_count() >= 2:
		# Update web line points
		var spider_pos = to_local(global_position)
		var anchor_pos = to_local(web_anchor_point)
		
		web_line.set_point_position(0, Vector2(anchor_pos))
		web_line.set_point_position(1, Vector2(spider_pos.x, spider_pos.y - 10))
		web_sprite.global_position = web_anchor_point


func hold_position(duration: float = 2.0):
	current_state = State.IDLE
	await get_tree().create_timer(duration).timeout
	current_state = State.ASCENDING


func on_hit() -> void:
	$RandomStreamPlayer2DComponent.play_random()
	
