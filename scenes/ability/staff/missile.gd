extends Node2D
class_name Missile

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@export var damage: int = 10

var direction: Vector2 = Vector2.RIGHT
var speed: float = 100.0

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	hitbox_component.damage = self.damage
	

func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta

func on_timer_timeout() -> void:
	queue_free()
