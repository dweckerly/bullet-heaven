extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

const CHEST_OPEN = preload("res://assets/objects/chest_open.png")
var opened = false

func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)
	timer.timeout.connect(on_timer_timeout)

func on_area_entered(other_area: Area2D):
	if opened:
		return
	opened = true
	sprite_2d.texture = CHEST_OPEN
	gpu_particles_2d.emitting = true
	timer.start()

func on_timer_timeout() -> void:
	gpu_particles_2d.emitting = false
