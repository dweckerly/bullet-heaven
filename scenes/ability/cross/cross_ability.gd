extends Node2D
class_name CrossAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var pixel_particles: GPUParticles2D = $PixelParticles
@onready var cross_particles: GPUParticles2D = $CrossParticles

func _ready() -> void:
	hitbox_component.knockback = 50
	pixel_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	cross_particles.emitting = true
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout() -> void:
	queue_free()
