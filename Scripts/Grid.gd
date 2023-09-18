extends Node2D


@onready var camera = get_viewport().get_camera_2d()


# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()


func _draw():
	# Draw X Axis
	var grid_offset_x = DisplayServer.window_get_size().x * (abs(camera.global_position.x) + 1)
	draw_line(Vector2.ZERO + Vector2.LEFT * grid_offset_x, Vector2.RIGHT * grid_offset_x, Color.RED, 1 / camera.zoom.x, true)
	
	# Draw Y axix
	var grid_offset_y = DisplayServer.window_get_size().y * (abs(camera.global_position.y) + 1) # 1 is added to counter 0 giving nothing
	draw_line(Vector2.ZERO + Vector2.UP * grid_offset_y, Vector2.DOWN * grid_offset_y, Color.BLUE, 1 / camera.zoom.x, true)
