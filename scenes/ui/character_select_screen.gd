extends CanvasLayer

@export var characters: Array[Character] = []
@onready var grid_container: GridContainer = %GridContainer
@onready var character_details_card: CharacterDetailsCard = $CharacterDetailsCard

var character_card_scene = preload("res://scenes/ui/character_card.tscn")
var character_details_scene = preload("res://scenes/ui/character_details_card.tscn")


func _ready() -> void:
	%BackButton.pressed.connect(on_back_pressed)
	character_details_card.visible = false
	for character in characters:
		var character_card_instance = character_card_scene.instantiate() as CharacterCard
		grid_container.add_child(character_card_instance)
		character_card_instance.set_character(character, MetaProgression.save_data["characters"][character.id]["locked"])
		character_card_instance.selected.connect(on_character_selected.bind(character))


func on_character_selected(character: Character) -> void:
	GameEvents.emit_character_selected(character)
	character_details_card.set_character_details(character)
	character_details_card.visible = true


func on_back_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
