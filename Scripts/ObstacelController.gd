extends Node2D

var ObstacelSpeed = 400

# Get Game Manager
@onready var GameManager = get_parent().find_child("GameManager")

func _process(delta):
	if !GameManager.GameOver:
		self.position += Vector2.LEFT * ObstacelSpeed * delta

func _on_obstacle_area_body_entered(_body):
	GameManager._on_hit_obstacle()

func _on_score_point_area_body_entered(_body):
	GameManager._on_score_point()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
