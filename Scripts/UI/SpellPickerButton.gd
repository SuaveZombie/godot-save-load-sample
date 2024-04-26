extends Button
class_name SpellPickerButton

# A simple toggle button for selecting spells in your loadout

var spell_id: int

signal on_spell_selected(button, selected)

func _on_toggled(toggled_on: bool) -> void:
	on_spell_selected.emit(self, toggled_on)
