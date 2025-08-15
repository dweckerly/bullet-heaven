extends Node2D
class_name BowAbility

@onready var hitbox_component = $HitboxComponent

var direction
var speed = 150
var max_hits: int = 2
var hits: int  = 0

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	hitbox_component.area_entered.connect(on_area_entered)


func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta


func on_timer_timeout() -> void:
	queue_free()


func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HurtboxComponent:
		return
	hits += 1
	if hits >= max_hits:
		queue_free()
