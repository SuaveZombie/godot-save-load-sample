extends Node

# This is a catch all script for doing your game setup, saving and loading data,
# doing game initialization, and storing any global state you need for the game to work

# This is your master dictionary of spells so you can easily query them in game via id
var spell_dict: Dictionary
func get_spell(id: int) -> SpellResource:
	if spell_dict[id] == null:
		print_debug("ERROR: Trying to access non-existant spell!")
		return null
	
	return spell_dict[id]
	
func get_spell_dict() -> Dictionary:
	return spell_dict

var next_spell_loadout_id: int = 0
var spell_loadouts_dict: Dictionary

func get_next_loadout_id() -> int:
	var id = next_spell_loadout_id
	next_spell_loadout_id += 1
	return id

func add_spell_loadout(name: String, spell_ids: Array[int]):
	var loadout: SpellLoadoutResource = SpellLoadoutResource.new()
	loadout.id = get_next_loadout_id()
	loadout.name = name
	loadout.spell_ids = spell_ids
	spell_loadouts_dict[loadout.id] = loadout
	on_loadout_created.emit(loadout)
	
# Other systems need to know when loadouts are created
signal on_loadout_created(loadout)
	
func get_spell_loadout(id: int) -> SpellLoadoutResource:
	if spell_loadouts_dict[id] == null:
		print_debug("ERROR: Trying to access non-existant loadout!")
		return null
	
	return spell_loadouts_dict[id]

func _ready() -> void:
	# load all your game resources first so they can be referenced when you load
	# save data and initialize other game state
	load_game_resources()

# This is a funny little thing you might have to do to load resources at runtime on all platforms
# Godot appends
func _clean_file_name(file_name: String) -> String:
	file_name = file_name.replace('.import', '')
	file_name = file_name.replace('.remap', '')
	return file_name

func load_game_resources():
	load_spell_resources()

func load_spell_resources():
	# Load all your premade spell resources into a dictionary so they're easy to query in game
	var file_path_prefix: String = "res://Resources/Spells/"
	var spell_dir: DirAccess = DirAccess.open(file_path_prefix)
	for spell_file_name in spell_dir.get_files():
		spell_file_name = file_path_prefix + _clean_file_name(spell_file_name)
		var spell_res: SpellResource = ResourceLoader.load(spell_file_name)
		var cur_id: int = spell_res.id
		if not spell_dict.has(cur_id):
			spell_dict[cur_id] = spell_res
		else:
			# this is useful to make sure your data is correct, IDs need to be unique
			print_debug("Found conflicting Spell ID!")
			print_debug("Name: ", spell_dict[cur_id].name, " ID: ", spell_dict[cur_id].id)
			print_debug("Name: ", spell_res.name, " ID: ", spell_res.id)

const SAVEFILE_NAME = "user://savegame.save"
func save_game():
	# As far as this sample project goes, all we really have to save are loadouts
	var savefile = FileAccess.open(SAVEFILE_NAME, FileAccess.WRITE)
	
	savefile.store_32(spell_loadouts_dict.values().size())
	for loadout in spell_loadouts_dict.values():
		savefile.store_32(loadout.name.length())
		savefile.store_string(loadout.name)
		savefile.store_32(loadout.spell_ids.size())
		for i in loadout.spell_ids.size():
			savefile.store_32(loadout.spell_ids[i])
		
func load_game():
	var savefile = FileAccess.open(SAVEFILE_NAME, FileAccess.READ)
	if savefile == null:
		print_debug("No save found!")
		return
	
	var num_loadouts = savefile.get_32()
	for i in num_loadouts:
		# we need to deserialize our save in the exact same order that we saved it in
		var name_length = savefile.get_32()
		var loadout_name: String
		for j in name_length:
			loadout_name += char(savefile.get_8())
			
		var num_spells = savefile.get_32()
		var spell_ids: Array[int]
		for j in num_spells:
			spell_ids.append(savefile.get_32())
			
		add_spell_loadout(loadout_name, spell_ids)
