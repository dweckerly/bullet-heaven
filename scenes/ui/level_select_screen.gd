extends CanvasLayer

@export var levels: Array[Level] = []
@onready var grid_container: GridContainer = %GridContainer

var level_card_scene = preload("res://scenes/ui/level_card.tscn")


func _ready() -> void:
	%BackButton.pressed.connect(on_back_pressed)
	for level in levels:
		var level_card_instance = level_card_scene.instantiate() as LevelCard
		grid_container.add_child(level_card_instance)
		level_card_instance.set_level(level)
		if not MetaProgression.save_data['levels'][level.id]['locked']:
			level_card_instance.use_parent_material = true
			level_card_instance.level_image.use_parent_material = true
			level_card_instance.selected.connect(on_level_selected.bind(level))


func on_level_selected(level: Level) -> void:
	ScreenTransition.transition_to_scene(level.path)


func on_back_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/character_select_screen.tscn")
