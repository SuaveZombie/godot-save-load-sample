extends Button
class_name SpellLoadoutButton

# A simple button that emits a signal to change the current loadout

var loadout_id: int

signal on_loadout_selected(id)

func _on_button_down() -> void:
	on_loadout_selected.emit(loadout_id)
