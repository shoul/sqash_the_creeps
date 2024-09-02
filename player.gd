extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed: int = 14
# The downward acceleration when in the air, in meters per second square.
@export var fall_acceleration: int = 75

var target_velocity: Vector3 = Vector3.ZERO


func _physics_process(delta):
	# We create a local varable to store the input direction.
	var direction: Vector3 = Vector3.ZERO
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# In 3D the XZ plane is the ground plane
		direction.z += 1
	if Input.is_action_pressed("move_foward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the base property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)
		
	# Ground VElocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	# If in the air, fall towwards the floor. Literally gravity.
	if not is_on_floor(): 
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
		# Moving the Character
		velocity = target_velocity
		move_and_slide()
