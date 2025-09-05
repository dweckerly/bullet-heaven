extends Camera2D

const CAMERA_SMOOTH: float = 20.0

var target_position = Vector2.ZERO

func _ready() -> void:
	make_current()

func _process(delta: float) -> void:
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * CAMERA_SMOOTH))


func acquire_target() -> void:
	if Global.get_player() != null:
		target_position = Global.get_player_global_pos()
