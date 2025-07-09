extends CanvasLayer

@export var characters: Array[Character] = []
@onready var grid_container: GridContainer = %GridContainer

var character_card_scene = preload("res://scenes/ui/character_card.tscn")


func _ready() -> void:
	%BackButton.pressed.connect(on_back_pressed)
	for character in characters:
		var character_card_instance = character_card_scene.instantiate() as CharacterCard
		grid_container.add_child(character_card_instance)
		character_card_instance.set_character(character)


func on_back_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
