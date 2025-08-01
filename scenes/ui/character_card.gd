extends PanelContainer
class_name CharacterCard

signal selected

@onready var character_sprite: TextureRect = %CharacterSprite
@onready var name_label: Label = %NameLabel

var locked: bool = true

func _ready() -> void:
	gui_input.connect(on_gui_input)


func set_character(character: Character, _locked: bool) -> void:
	locked = _locked
	character_sprite.texture = character.sprite
	name_label.text = character.display_name
	if locked:
		self.modulate = Color(0.5, 0.5, 0.5, 1.0)
		character_sprite.modulate = Color(0.0, 0.0, 0.0, 1)
		name_label.text = "???"
	


func select_card() -> void:
	$RandomAudioStreamPlayerComponent.play_random()
	selected.emit()


func on_gui_input(event: InputEvent) -> void:
	if locked:
		return
	if event.is_action_pressed("left_click"):
		select_card()
	
