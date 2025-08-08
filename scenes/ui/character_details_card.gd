extends CanvasLayer
class_name CharacterDetailsCard

@onready var weapon_sprite: Sprite2D = %WeaponSprite
@onready var weapon_name: Label = %WeaponName
@onready var character_name: Label = %CharacterName
@onready var modifiers: Label = %Modifiers


func set_character_details(character: Character) -> void:
	weapon_sprite.texture = character.starting_ability.image
	weapon_name.text = character.starting_ability.name
	character_name.text = character.display_name
	modifiers.text = create_modifier_string(character.modifiers)
	

func create_modifier_string(modifiers: Dictionary) -> String:
	var return_string: String = ""
	if modifiers[Modifiers.AMOUNT]['value'] > 0:
		return_string += "+" + str(modifiers[Modifiers.AMOUNT]['value']) + " projectile to all weapons\n"
	
	if modifiers[Modifiers.COOLDOWN]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.COOLDOWN]['value'] * 100))) + "%"
		if modifiers[Modifiers.COOLDOWN]['level_up']:
			if modifiers[Modifiers.COOLDOWN]['value'] > 0:
				return_string += percent + " cooldown increase per level up\n"
			else:
				return_string += percent + " cooldown decrease per level up\n"
		else:
			if modifiers[Modifiers.COOLDOWN]['value'] > 0:
				return_string += percent + " increased cooldown\n"
			else:
				return_string += percent + " reduced cooldown\n"
	
	if modifiers[Modifiers.DAMAGE]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.DAMAGE]['value'] * 100))) + "%"
		if modifiers[Modifiers.DAMAGE]['level_up']:
			if modifiers[Modifiers.DAMAGE]['value'] > 0:
				return_string += percent + " damage increase per level up\n"
			else:
				return_string += percent + " damage decrease per level up\n"
		else:
			if modifiers[Modifiers.DAMAGE]['value'] > 0:
				return_string += percent + " increased damage\n"
			else:
				return_string += percent + " reduced damage\n"
	
	if modifiers[Modifiers.LIVES]['value'] != 0:
		return_string += "+" + str(modifiers[Modifiers.LIVES]['value']) + " lives\n"
	
	if modifiers[Modifiers.MAX_HEALTH]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.MAX_HEALTH]['value'] * 100))) + "%"
		if modifiers[Modifiers.MAX_HEALTH]['level_up']:
			if modifiers[Modifiers.MAX_HEALTH]['value'] > 0:
				return_string += percent + " health increase per level up\n"
			else:
				return_string += percent + " health decrease per level up\n"
		else:
			if modifiers[Modifiers.MAX_HEALTH]['value'] > 0:
				return_string += percent + " increased health\n"
			else:
				return_string += percent + " reduced health\n"
	
	if modifiers[Modifiers.MOVE_SPEED]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.MOVE_SPEED]['value'] * 100))) + "%"
		if modifiers[Modifiers.MOVE_SPEED]['level_up']:
			if modifiers[Modifiers.MOVE_SPEED]['value'] > 0:
				return_string += percent + " move speed increase per level up\n"
			else:
				return_string += percent + " move speed decrease per level up\n"
		else:
			if modifiers[Modifiers.MOVE_SPEED]['value'] > 0:
				return_string += percent + " increased move speed\n"
			else:
				return_string += percent + " reduced move speed\n"
		
	if modifiers[Modifiers.REACH]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.REACH]['value'] * 100))) + "%"
		if modifiers[Modifiers.REACH]['level_up']:
			if modifiers[Modifiers.REACH]['value'] > 0:
				return_string += percent + " pickup reach increase per level up\n"
			else:
				return_string += percent + " pickup reach decrease per level up\n"
		else:
			if modifiers[Modifiers.REACH]['value'] > 0:
				return_string += percent + " increased pickup reach\n"
			else:
				return_string += percent + " reduced pickup reach\n"
		
	if modifiers[Modifiers.SIZE]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.SIZE]['value'] * 100))) + "%"
		if modifiers[Modifiers.SIZE]['level_up']:
			if modifiers[Modifiers.SIZE]['value'] > 0:
				return_string += percent + " weapon size increase per level up\n"
			else:
				return_string += percent + " weapon size decrease per level up\n"
		else:
			if modifiers[Modifiers.SIZE]['value'] > 0:
				return_string += percent + " increased weapon size\n"
			else:
				return_string += percent + " reduced weapon size\n"
			
	if modifiers[Modifiers.SPEED]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.SPEED]['value'] * 100))) + "%"
		if modifiers[Modifiers.SPEED]['level_up']:
			if modifiers[Modifiers.SPEED]['value'] > 0:
				return_string += percent + " weapon speed increase per level up\n"
			else:
				return_string += percent + " weapon speed decrease per level up\n"
		else:
			if modifiers[Modifiers.SPEED]['value'] > 0:
				return_string += percent + " increased weapon speed\n"
			else:
				return_string += percent + " reduced weapon speed\n"
		
	if modifiers[Modifiers.XP_GAIN]['value'] != 0:
		var percent = str(abs(int(modifiers[Modifiers.XP_GAIN]['value'] * 100))) + "%"
		if modifiers[Modifiers.XP_GAIN]['level_up']:
			if modifiers[Modifiers.XP_GAIN]['value'] > 0:
				return_string += percent + " xp gain increase per level up\n"
			else:
				return_string += percent + " xp gain decrease per level up\n"
		else:
			if modifiers[Modifiers.XP_GAIN]['value'] > 0:
				return_string += percent + " increased xp gain\n"
			else:
				return_string += percent + " reduced xp gain\n"
	
	return return_string.left(return_string.length() - 1)
