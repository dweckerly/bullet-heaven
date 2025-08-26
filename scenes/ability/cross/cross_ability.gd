extends Node2D
class_name CrossAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var pixel_particles: GPUParticles2D = $Visuals/PixelParticles
@onready var cross_particles: GPUParticles2D = $Visuals/CrossParticles
@onready var visuals: Node2D = $Visuals
@onready var collision_shape_2d: CollisionShape2D = $HitboxComponent/CollisionShape2D

var scale_mod: float = 1.0

func _ready() -> void:
	hitbox_component.knockback = 50
	pixel_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	cross_particles.emitting = true
	$Timer.timeout.connect(on_timer_timeout)
	visuals.scale *= scale_mod
	collision_shape_2d.scale *= scale_mod

func on_timer_timeout() -> void:
	queue_free()
