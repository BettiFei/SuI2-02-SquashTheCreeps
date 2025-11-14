extends Node

@export var mob_scene : PackedScene
@onready var player = $Player

func _on_mob_timer_timeout() -> void:
	# create new instance of the mob scene:
	var mob = mob_scene.instantiate()
	
	# choose random point on SpawnPath:
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# spawn new mob by adding it to Main scene:
	add_child(mob)
