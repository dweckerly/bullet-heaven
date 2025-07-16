extends Node2D
class_name BowAbility

var direction

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return


func shoot() -> void:
	pass


func on_timer_timeout() -> void:
	queue_free()
