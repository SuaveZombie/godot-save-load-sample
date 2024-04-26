extends Resource
class_name SpellResource

# This is an example of a spell! Everything in here is created by the developer and can be treated
# as 'static data'. They are predefined in res://Resources/Spells and loaded when the game starts
# so they are globally accessible with Game.get_spell.

@export var id: int
@export var name: String
@export var icon: Texture2D
