extends Node

@export var mob_scene: PackedScene

@onready var retry: ColorRect = %Retry



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	# Create the variables
	var mob: CharacterBody3D
	var mob_spawn_location: PathFollow3D
	var player_position: Vector3
	var score_label = %ScoreLabel
	
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
	
	# Connect the mob to the score label to update the score upon squashing one
	mob.squashed.connect(score_label._on_mob_squashed.bind())


func _on_player_hit() -> void:
	$MobTimer.stop()
	retry.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and retry.visible:
		get_tree().reload_current_scene()
