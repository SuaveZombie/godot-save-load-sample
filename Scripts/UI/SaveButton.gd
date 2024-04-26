extends Button

# A simple button to save the game

func _on_button_down() -> void:
	Game.save_game()
