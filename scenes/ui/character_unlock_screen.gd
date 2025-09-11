extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	animation_player.play("in")

func unlock_animation(character: Character) -> void:
	texture_rect.texture = character.sprite
	label.text = "\n\n" + character.display_name + " UNLOCKED!"
	animation_player.play("character_in")
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	queue_free()
