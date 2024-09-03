extends CharacterBody3D

# Minimum speed of the mob in m / s
@export var min_speed: int = 10
# Maximum speed of the mob in m / s
@export var max_speed: int = 18


func _physics_process(_delta):
	move_and_slide()


# This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We positon the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that is doesn't move directly towards the player every time.
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# We calculate a random speed (integer)
	var random_speed: int = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
