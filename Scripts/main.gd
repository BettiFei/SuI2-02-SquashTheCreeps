extends Node

@export var mob_scene : PackedScene
@onready var player = $Player


func _ready():
	new_game()

func new_game():
	$UserInterface/HealthBar.max_value = player.hp
	$UserInterface/HealthBar.value = player.hp
	#$UserInterface/HealthLabel.text = "HP: %s" % player.hp
	$UserInterface/Retry.hide()


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
	
	# connect mob to score label to increase score when squashed:
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_died() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
