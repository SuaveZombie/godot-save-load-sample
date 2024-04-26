extends Control
class_name SpellLoadoutManager

# This script tells the Game singleton to create a loadout with the currently selected spells
# and the name entered in the TextEdit box

@export var spell_picker: SpellPicker
@export var save_button: Button
@export var loadout_name: TextEdit

func _on_save_loadout_button_button_down() -> void:
	var loadout_name_text = loadout_name.text
	if loadout_name_text == "":
		loadout_name_text = "Default"
	
	# Best to let the Game singleton manage resource creation
	Game.add_spell_loadout(loadout_name_text, spell_picker.selected_spells)
	
	loadout_name.text = ""
