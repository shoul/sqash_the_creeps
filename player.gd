extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
# Vertical impuleapplied to the character upon jumping in meter per second.
@export var jump_impulse = 20
# Vertical impulse applied to the caracter upon bouncing over a mob in
# meters per second.
@export var bounce_impulse = 16

var target_velocity: Vector3 = Vector3.ZERO


func _physics_process(delta):
	var direction = Vector3.ZERO
	var collision
	var collided_mob

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		collision = get_slide_collision(index)
	
		# If the collision is with the ground
		if collision.get_collider() == null:
			continue
		
		# If the collision is with a mob
		if collision.get_collider().is_in_group("mob"):
			collided_mob = collision.get_collider()
			# We check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal() > 0.1):
				# If so, we sqash it and bounce.
				collided_mob.sqash()
				target_velocity.y = bounce_impulse
				# Prevent futher duplicate calls.
				break
				

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
