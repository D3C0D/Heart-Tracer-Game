extends Control

var AnimationEnd = false

@onready var StartLabel = $Start
@onready var player = $MenuAnimation

func _process(_delta):
	if Input.is_action_just_pressed("Jump") and AnimationEnd:
		get_tree().change_scene_to_file("res://Scenes/GameWorld.tscn")
	elif Input.is_action_just_pressed("Jump") and !AnimationEnd:
		finish_animation()

func _on_start_timer_timeout():
	if AnimationEnd:
		StartLabel.visible = !StartLabel.visible

func _on_menu_animation_animation_finished(anim_name):
	AnimationEnd = true

# Function to finish the current animation immediately
func finish_animation():
	if player.is_playing():
		var current_anim_name = player.get_current_animation()
		if current_anim_name:
			var remaining_time = player.get_animation(current_anim_name).length - player.get_current_animation_position()
			player.advance(remaining_time)
