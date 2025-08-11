extends Node2D

@export var character_id: String

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)
	

func on_area_entered(area2d: Area2D) -> void:
	MetaProgression.unlock_character(character_id)
	queue_free()
