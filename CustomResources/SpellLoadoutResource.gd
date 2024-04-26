extends Resource
class_name SpellLoadoutResource

# This is an example of a spell loadout! These are created by the player in the game and are considered
# 'dynamic data'. We *do not* define these upfront (but you can if you want to, as an example for the player!)
# and they they only exist in memory until they get saved to disk in the savefile.

var id: int

# User generated name
@export var name: String

# This is where being data-driven can shine! We don't need to worry about what spell resources
# look like at all nor keep a reference to them. We know they will be loaded by the time we need them
# in game so all we care about is the IDs that will get written to the savefile.
@export var spell_ids: Array[int]
