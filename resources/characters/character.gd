extends Resource
class_name Character

@export var id: String
@export var display_name: String
@export var sprite: Texture2D
@export var starting_ability: Ability
@export var modifiers: Dictionary = {
	Modifiers.AMOUNT: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.COOLDOWN: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.DAMAGE: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.LIVES: { 'value': 0},
	Modifiers.MAX_HEALTH: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.MOVE_SPEED: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.REACH: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.SIZE: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.SPEED: { 'value': 0.0, 'level_up': false, 'max': 1.0},
	Modifiers.XP_GAIN: { 'value': 0.0, 'level_up': false, 'max': 1.0},
}
