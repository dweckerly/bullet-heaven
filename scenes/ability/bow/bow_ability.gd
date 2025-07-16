extends Node2D
class_name BowAbility

@onready var hitbox_component = $HitboxComponent

var direction
var speed = 100

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta


func on_timer_timeout() -> void:
	queue_free()
