extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = $%NameLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer
@onready var description_label: Label = $%DescriptionLabel

var disabled: bool = false


func _ready() -> void:
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in_animation(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	if (delay > 0):
		await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func play_discard_animation() -> void:
	animation_player.play("discard")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card() -> void:
	disabled = true
	animation_player.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card") as Array[AbilityUpgradeCard]:
		if other_card == self:
			continue
		other_card.play_discard_animation()
	await animation_player.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
	if event.is_action_pressed("left_click"):
		select_card()


func on_mouse_entered() -> void:
	if disabled:
		return
	hover_animation_player.play("hover")
