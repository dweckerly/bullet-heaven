extends PanelContainer
class_name MetaUpgradeCard


@onready var name_label: Label = $%NameLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel

var meta_upgrade: MetaUpgrade


func _ready() -> void:
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade):
	meta_upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()
	

func update_progress() -> void:
	var current_quantity = 0
	if meta_upgrade.id in MetaProgression.save_data["meta_upgrades"]:
		current_quantity = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["quantity"]
	var is_maxxed = current_quantity >= meta_upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / meta_upgrade.xp_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxxed
	if is_maxxed:
		purchase_button.text = "MAXXED"
	progress_label.text = str(int(currency)) + "/" + str(meta_upgrade.xp_cost)
	count_label.text = "x%d" % current_quantity


func select_card() -> void:
	animation_player.play("selected")


func on_purchase_pressed() -> void:
	if meta_upgrade == null:
		return
	MetaProgression.add_meta_upgrade(meta_upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= meta_upgrade.xp_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	select_card()
