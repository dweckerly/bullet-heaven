extends CanvasLayer

@export var xp_manager: XPManager
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar
@onready var level_text: Label = $MarginContainer/VBoxContainer/LevelText

func _ready() -> void:
	progress_bar.value = 0
	xp_manager.xp_updated.connect(on_xp_updated)
	

func on_xp_updated(current_xp: float, target_xp: float):
	var percent = current_xp / target_xp
	progress_bar.value = percent
	level_text.text = "Level: " + str(xp_manager.current_level)
