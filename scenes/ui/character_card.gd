extends PanelContainer
class_name CharacterCard

@onready var character_sprite: TextureRect = %CharacterSprite

func set_character(character: Character) -> void:
	character_sprite.texture = character.sprite
