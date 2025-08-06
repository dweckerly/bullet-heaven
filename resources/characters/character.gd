extends Resource
class_name Character

@export var id: String
@export var display_name: String
@export var sprite: Texture2D
@export var starting_ability: Ability
@export var modifiers: Dictionary = {
	Modifiers.AMOUNT: 0,
	Modifiers.COOLDOWN: 0,
	Modifiers.DAMAGE: 0,
	Modifiers.LIVES: 0,
	Modifiers.MAX_HEALTH: 0,
	Modifiers.MOVE_SPEED: 0,
	Modifiers.REACH: 0,
	Modifiers.SIZE: 0,
	Modifiers.SPEED: 0,
	Modifiers.XP_GAIN: 0
}
