extends Camera3D

@onready var animation = $AnimationPlayer

func _on_player_hit(_hp) -> void:
	animation.play("damage")
