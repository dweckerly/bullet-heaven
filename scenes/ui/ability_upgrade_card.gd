extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel

func _ready() -> void:
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in_animation(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	if (delay > 0):
		await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		selected.emit()


func on_mouse_entered() -> void:
	$HoverAnimationPlayer.play("hover")
