extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var velocity_component: VelocityComponent = $VelocityComponent 

var base_scale: Vector2

func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)
	base_scale = visuals.scale

func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign * base_scale.x, base_scale.y)


func on_hit() -> void:
	$RandomStreamPlayer2DComponent.play_random()
	
