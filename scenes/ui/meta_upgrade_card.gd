extends PanelContainer
class_name MetaUpgradeCard


@onready var name_label: Label = $%NameLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton

var meta_upgrade: MetaUpgrade


func _ready() -> void:
	purchase_button.pressed.connect(on_purchase_pressed)
	gui_input.connect(on_gui_input)


func set_meta_upgrade(upgrade: MetaUpgrade):
	meta_upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()
	

func update_progress() -> void:
	var percent = MetaProgression.save_data["meta_upgrade_currency"] / meta_upgrade.xp_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1


func select_card() -> void:
	animation_player.play("selected")


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		select_card()


func on_purchase_pressed() -> void:
	if meta_upgrade == null:
		return
	MetaProgression.add_meta_upgrade(meta_upgrade)
