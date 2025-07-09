extends CanvasLayer

signal transition_halfway

var skip_emit: bool = false


func transition() -> void:
	$AnimationPlayer.play("default")
	await transition_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("default")


func transition_to_scene(scene_path: String) -> void:
	transition()
	await transition_halfway
	get_tree().change_scene_to_file(scene_path)


func emit_transitioned_halfway() -> void:
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()
