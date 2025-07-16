extends PanelContainer
class_name CharacterCard

signal selected

@onready var character_sprite: TextureRect = %CharacterSprite
@onready var name_label: Label = %NameLabel

func _ready() -> void:
	gui_input.connect(on_gui_input)


func set_character(character: Character) -> void:
	character_sprite.texture = character.sprite
	name_label.text = character.display_name


func select_card() -> void:
	selected.emit()


func on_gui_input(event: InputEvent) -> void:
	#if disabled:
		#return
	if event.is_action_pressed("left_click"):
		select_card()
	
