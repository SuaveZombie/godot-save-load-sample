extends VBoxContainer

@export var spell_loadout_manager: SpellLoadoutManager
@export var spell_slots: SpellSlots
const SPELL_LOADOUT_BUTTON = preload("res://UI/SpellLoadoutButton.tscn")

func _ready() -> void:
	Game.on_loadout_created.connect(loadout_created)

func loadout_created(loadout: SpellLoadoutResource):
	var button: SpellLoadoutButton = SPELL_LOADOUT_BUTTON.instantiate()
	button.loadout_id = loadout.id
	button.text = loadout.name
	button.on_loadout_selected.connect(on_loadout_selected)
	add_child(button)

func on_loadout_selected(loadout_id: int):
	spell_slots.load_loadout(loadout_id)
