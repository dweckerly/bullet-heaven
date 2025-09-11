extends Node2D

@export var character: Character
@export var unlock_screen: PackedScene

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)
	

func on_area_entered(area2d: Area2D) -> void:
	MetaProgression.unlock_character(character.id)
	var cu_screen = unlock_screen.instantiate()
	get_tree().root.add_child(cu_screen)
	cu_screen.unlock_animation(character)
	queue_free()
