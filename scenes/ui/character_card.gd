extends PanelContainer
class_name CharacterCard

@onready var character_sprite: TextureRect = %CharacterSprite
@onready var name_label: Label = %NameLabel

func set_character(character: Character) -> void:
	character_sprite.texture = character.sprite
	name_label.text = character.display_name
