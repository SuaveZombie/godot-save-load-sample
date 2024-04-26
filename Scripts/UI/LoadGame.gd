extends Button

# A simple button that loads the game

func _on_button_down() -> void:
	Game.load_game()
