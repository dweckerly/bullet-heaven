extends CanvasLayer

signal transition_halfway

var skip_emit: bool = false


func transition() -> void:
	$AnimationPlayer.play("default")
	await transition_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("default")


func emit_transitioned_halfway() -> void:
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()
