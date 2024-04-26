extends VBoxContainer
class_name SpellPicker

const SPELL_PICKER_BUTTON = preload("res://UI/SpellPickerButton.tscn")
var spell_buttons: Array[SpellPickerButton]
var selected_spells: Array[int]
var num_selectable_spells: int = 3

func _ready() -> void:
	Game.on_loadout_created.connect(on_loadout_created)
	
	var spell_dict: Dictionary = Game.get_spell_dict()
	var spell_list: Array = spell_dict.values()
	# optional, but I want my spell buttons in ID order
	spell_list.sort_custom(sort_by_id)
	for spell in spell_list:
		var button: SpellPickerButton = SPELL_PICKER_BUTTON.instantiate()
		button.spell_id = spell.id
		button.text = spell.name
		spell_buttons.append(button)
		add_child(button)
		
	for button in spell_buttons:
		button.on_spell_selected.connect(on_spell_selected)

func sort_by_id(a: SpellResource, b: SpellResource):
	if a.id < b.id:
		return true
	return false

func on_spell_selected(spell_button: SpellPickerButton, selected: bool):
	if selected and selected_spells.size() < num_selectable_spells:
		selected_spells.append(spell_button.spell_id)
	elif not selected:
		selected_spells.erase(spell_button.spell_id)
		
	# Disables the rest of the buttons so we can only select up to num_selectable_spells
	if selected_spells.size() == num_selectable_spells:
		for button in spell_buttons:
			if not button.button_pressed:
				button.disabled = true
	# Turn them back on if we can pick more spells
	else:
		for button in spell_buttons:
			if not button.button_pressed:
				button.disabled = false

func on_loadout_created(loadout: SpellLoadoutResource):
	# Just for convenience, unselect buttons after saving a loadout
	selected_spells = []
	for button in spell_buttons:
		button.disabled = false
		button.set_pressed_no_signal(false)
	
