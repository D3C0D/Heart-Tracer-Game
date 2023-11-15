extends RigidBody2D

signal StartGameSignal

var JumpForce = 500
var GameOver = false
var StartGame = false

func _ready():
	set_freeze_enabled(true)
	set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)

func _process(_delta):
	# Process input and apply jump force
	if Input.is_action_just_pressed("Jump") and !GameOver:
		set_freeze_enabled(false)
		linear_velocity = Vector2.ZERO
		apply_central_impulse(Vector2.UP * JumpForce)
		if !StartGame:
			StartGame = true
			StartGameSignal.emit()
	
	# When the game is over, freeze physics
	if GameOver:
		set_freeze_enabled(true)

func _on_game_manager_is_game_over():
	GameOver = true
