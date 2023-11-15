extends Node2D

var line_speed = 600  # Speed at which the line points move to the left
var line_points = []
@onready var line2d_node = $Line2D
@onready var tracer_node = get_parent().find_child("Tracer") # The Tracer node whose position we're tracking

# Called when the node enters the scene tree for the first time.
func _ready():
	add_tracer_point()  # Add the initial point

# Function to add points to the line based on the Tracer node's position
func add_tracer_point():
	# Get the local position of the tracer relative to the Line2D node
	var local_position = line2d_node.to_local(tracer_node.global_position)
	# Insert this new point at the start of the line_points array
	line_points.insert(0, local_position)
	# Update the Line2D's points directly
	line2d_node.points = line_points

# Function to update the position of the points
func update_line_points(delta):
	for i in range(1, line_points.size()):
		line_points[i].x -= line_speed * delta  # Move points to the left
	# Always keep the first point at the tracer's current position
	line_points[0] = line2d_node.to_local(tracer_node.global_position)
	# Update the Line2D's points directly
	line2d_node.points = line_points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_line_points(delta)
