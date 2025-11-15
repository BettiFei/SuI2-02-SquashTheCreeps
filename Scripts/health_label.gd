extends Label


func _on_player_hit(hp) -> void:
	text = "HP: " + str(hp)
