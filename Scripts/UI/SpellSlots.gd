extends Node
class_name SpellSlots

# This script displays the spells in your loadout at the bottom of the screen

@onready var spell_slot_0: Sprite2D = $Spell_Slot_0
@onready var spell_slot_1: Sprite2D = $Spell_Slot_1
@onready var spell_slot_2: Sprite2D = $Spell_Slot_2
var spell_slots: Array[Sprite2D]

const DEFAULT = preload("res://Resources/Loadouts/Default.tres")
var spell_loadout_res: SpellLoadoutResource

func _ready() -> void:
	# fallback to default loadout, we could load this the same way as our other resources
	# in Game.gd, but we can skip it since its a one off. If you have multiple you'll want to do
	# it properly
	spell_loadout_res = DEFAULT
	init_spell_slots()
	populate_spell_slots()
	
func load_loadout(loadout_id: int):
	spell_loadout_res = Game.get_spell_loadout(loadout_id)
	populate_spell_slots()

func init_spell_slots():
	spell_slots.append(spell_slot_0)
	spell_slots.append(spell_slot_1)
	spell_slots.append(spell_slot_2)

func populate_spell_slots():
	for i in spell_slots.size():
		if i < spell_loadout_res.spell_ids.size():
			spell_slots[i].visible = true
			var spell: SpellResource = Game.get_spell(spell_loadout_res.spell_ids[i])
			spell_slots[i].texture = spell.icon
		else:
			spell_slots[i].visible = false
