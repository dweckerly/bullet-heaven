extends Node

@onready var timer = $Timer

func get_time_elapsed():
	return timer.time_left
