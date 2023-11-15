extends Node2D

# Signal Game Over
signal is_GameOver
signal new_Trace

# System Variables
var Score = 0
var MaxScore = 0
var GameOver = true
var ObstaclePrefab = preload("res://Prefabs/Obstacle.tscn")
var GlobalGameSpeed = 600
var BPM = 60
var CurrentEffect = 1

# Other Nodes References
@onready var ObstacleTimer = $ObstacleTimer
@onready var EffectTimer = $EffectsTimer
@onready var RNG = RandomNumberGenerator.new()
# UI
@onready var UI = $"Game UI"
@onready var ScoreLabel = $"Game UI/MarginContainer2/TotalBeats"
@onready var BPMLabel = $"Game UI/MarginContainer/BPM"
@onready var GameOverScreen = $GameOverScreen
@onready var GameOverScore = $GameOverScreen/GameOverScore
@onready var NewEffectAnimation = $NewEffect/NewEffectAnimation
@onready var NewEffectLabel = $NewEffect/EffectLabel
# Player
@onready var Tracer = get_parent().find_child("Tracer")
# Sound
@onready var BeepSound = $BeepSound
@onready var DeathBeepSound = $DeathBeepSound
@onready var NewEffectSound = $NewEffectSound

func _ready():
	MaxScore = load_value_from_file()
	RNG.randomize()

func _process(_delta):
	if Input.is_action_just_pressed("Jump") and GameOver:
		get_tree().reload_current_scene()
	elif Input.is_action_just_pressed("ui_cancel") and GameOver:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _spawn_obstacle():
	if !GameOver:
		var temp_obstacle = ObstaclePrefab.instantiate()
		temp_obstacle.set_position(Vector2(1280, RNG.randi_range(200, 520)))
		temp_obstacle.ObstacelSpeed = GlobalGameSpeed
		get_parent().add_child(temp_obstacle)

func _on_score_point():
	if !GameOver:
		Score += 1
		ScoreLabel.text = "Total Beats: " + str(Score)
		BeepSound.play()
		new_Trace.emit()

func _on_hit_obstacle():
	if !GameOver:
		if Score > MaxScore:
			save_value_to_file(Score)
			GameOverScore.text = "You made a new high!\nMost Heart Beats: " + str(Score)
		else:
			GameOverScore.text = "Heart Beats: " + str(Score) + "\nMost  Heart Beats: " + str(MaxScore)
		GameOverScreen.visible = true
		UI.visible = false
		EffectTimer.stop()
		GameOver = true
		DeathBeepSound.play()
		is_GameOver.emit()

func _on_obstacle_timer_timeout():
	BPMLabel.text = "BPM: " + str(RNG.randi_range(BPM - 4, BPM + 4))
	_spawn_obstacle()


func _on_tracer_start_game_signal():
	GameOver = false
	EffectTimer.start()

# Function to save an integer to a file
func save_value_to_file(value: int, file_path: String = "user://save_file.txt"):
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.WRITE)
	if file:
		file.store_32(value)
		file.close()

# Function to load an integer from a file
func load_value_from_file(file_path: String = "user://save_file.txt") -> int:
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
		if file:
			var value = file.get_32()
			file.close()
			return value
	return 0  # Return a default value if the file doesn't exist or an error occurred


func _on_effects_timer_timeout():
	var temp_random = RNG.randi_range(1, 3)
	while temp_random == CurrentEffect:
		temp_random = RNG.randi_range(1, 3)
	CurrentEffect = temp_random
	if temp_random == 1:
		NewEffectLabel.text = "Heartbeat Normalized"
		NewEffectAnimation.play("NewEffectAnimation")
		BPM = 60
		ObstacleTimer.wait_time = 1
	elif temp_random == 2:
		NewEffectLabel.text = "Paient has Tachycardia!"
		NewEffectAnimation.play("NewEffectAnimation")
		BPM = 120
		ObstacleTimer.wait_time = 0.5
	elif temp_random == 3:
		NewEffectLabel.text = "Paient has Bradycardia!"
		NewEffectAnimation.play("NewEffectAnimation")
		BPM = 30
		ObstacleTimer.wait_time = 2
