extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	# input handling:
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	# making sure that character moves at consistent speed, even if two direction inputs are given simultaneously:
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	# ground velocity:
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# vertical velocity:
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# jumping:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# SQUASHING & BOUNCING
	# iterating over all collisions:
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		# when iterating with the same object twice, second collision will return null -> make sure to continue anyway:
		if collision.get_collider() == null:
			continue
		
		# if colliding with a mob:
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# if player hits mob from above, squash it & bounce off:
			#print(Vector3.UP.dot(collision.get_normal()))
			if Vector3.UP.dot(collision.get_normal()) > 0.6:
				mob.squash()
				target_velocity.y = bounce_impulse
				# prevent further duplicate calls:
				break
	
	# moving the character:
	velocity = target_velocity
	move_and_slide()
