extends PanelContainer
class_name LevelCard

signal selected

@onready var level_image: TextureRect = %LevelImage
@onready var name_label: Label = %NameLabel
@onready var description: Label = %Description

func _ready() -> void:
	gui_input.connect(on_gui_input)


func set_level(level: Level) -> void:
	level_image.texture = level.picture
	name_label.text = level.display_name
	description.text = level.description


func select_card() -> void:
	selected.emit()


func on_gui_input(event: InputEvent) -> void:
	#if disabled:
		#return
	if event.is_action_pressed("left_click"):
		select_card()
	
