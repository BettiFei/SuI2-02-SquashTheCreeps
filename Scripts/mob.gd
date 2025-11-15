extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

signal squashed

func _physics_process(_delta: float) -> void:
	move_and_slide()

func initialize(start_position, player_position):
	# position mob at given start_position, then make it look at player:
	var target = Vector3(player_position.x, start_position.y, player_position.z)
	look_at_from_position(start_position, target, Vector3.UP)
	# rotate a little so it doesn't move straight towards player:
	rotate_y(randf_range(-PI / 4, PI / 4))
	# give random speed:
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	# move velocity so that mob moves in the direction it is looking:
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()
