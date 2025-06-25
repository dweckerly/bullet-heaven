extends CanvasLayer

@export var xp_manager: XPManager
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready() -> void:
	progress_bar.value = 0
	xp_manager.xp_updated.connect(on_xp_updated)
	

func on_xp_updated(current_xp: float, target_xp: float):
	var percent = current_xp / target_xp
	progress_bar.value = percent
