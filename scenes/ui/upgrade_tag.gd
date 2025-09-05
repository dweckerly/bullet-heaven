extends MarginContainer

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label

func set_tag_props(image, val) -> void:
	texture_rect.texture = image
	label.text = str(val)
