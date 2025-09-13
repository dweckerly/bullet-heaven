extends Node2D

@export var character: Character
@export var unlock_screen: PackedScene

@onready var blood_particles: GPUParticles2D = $Visuals/BloodParticles
@onready var gold_particles: GPUParticles2D = $Visuals/GoldParticles
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var area_2d: Area2D = $Area2D

const HEART = preload("res://assets/objects/heart.png")
var locked: bool = true 

func _ready() -> void:
	locked = MetaProgression.save_data['characters'][character.id]['locked']
	if locked:
		area_2d.area_entered.connect(on_area_entered_locked)
	else:
		sprite_2d.texture = HEART
		blood_particles.emitting = false
		area_2d.area_entered.connect(on_area_entered_unlocked)

func on_area_entered_locked(area2d: Area2D) -> void:
	MetaProgression.unlock_character(character.id)
	var cu_screen = unlock_screen.instantiate()
	get_tree().root.add_child(cu_screen)
	cu_screen.unlock_animation(character)
	queue_free()


func on_area_entered_unlocked(area2d: Area2D) -> void:
	sprite_2d.visible = false
	gold_particles.emitting = true
	await get_tree().create_timer(5).timeout
	queue_free()
