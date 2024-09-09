extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	# Create the variables
	var mob: CharacterBody3D
	var mob_spawn_location: PathFollow3D
	var player_position: Vector3
	
	# Create a new instance of the Mob scene.
	mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	mob_spawn_location = $SpawnPath/Spawnlocation
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
