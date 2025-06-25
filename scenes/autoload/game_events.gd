extends Node

signal xp_gem_collected(number: float)

func emit_xp_gem_collected(number: float):
	xp_gem_collected.emit(number)
