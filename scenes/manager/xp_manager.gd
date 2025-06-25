extends Node
class_name XPManager

signal xp_updated(current_xp: float, target_xp: float)
const TARGET_XP_GROWTH: float = 5

var current_xp: float = 0
var current_level: int = 1
var target_xp: float = 5

func _ready() -> void:
	GameEvents.xp_gem_collected.connect(on_xp_gem_collected)


func increment_xp(number: float) -> void:
	current_xp = min(current_xp + number, target_xp)
	xp_updated.emit(current_xp, target_xp)
	if current_xp == target_xp:
		current_level += 1
		target_xp += TARGET_XP_GROWTH
		current_xp = 0
		xp_updated.emit(current_xp, target_xp)


func on_xp_gem_collected(number:float) -> void:
	increment_xp(number)
