extends Node2D

class_name Axis

@onready var camera := get_viewport().get_camera_2d()

@export var draw_vertical := true
@export var draw_horizontal := true
@export var position_vector := Vector2.ZERO
@export var line_width := 2.0
@export var verticalColor := Color.BLUE
@export var horizontalColor := Color.RED

var axis := AxisResource.new()


func _ready():
	camera.camera_moved.connect(queue_redraw)
	update_axis()
	queue_redraw()
	
	Globals.snappable_axis.append(axis)


func update_axis():
	axis.horizontal_axis = draw_horizontal
	axis.vertical_axis = draw_vertical
	axis.axis_position = position_vector


func _draw():
	update_axis()
	# Base behaviour for orign
	if draw_vertical:
		draw_screen_line(true, position_vector)
	if draw_horizontal:
		draw_screen_line(false, position_vector)


func draw_screen_line(vertical := true, startVector := Vector2.ZERO):
	if vertical:
		var grid_offset_y = DisplayServer.window_get_size().y * (abs(camera.global_position.y) + 1) / camera.zoom.y # 1 is added to counter 0 giving nothing
		draw_line(startVector + Vector2.UP * grid_offset_y, startVector + Vector2.DOWN * grid_offset_y, verticalColor, line_width / camera.zoom.x, true)
	else:
		var grid_offset_x = DisplayServer.window_get_size().x * (abs(camera.global_position.x) + 1) / camera.zoom.x # 1 is added to counter 0 giving nothing
		draw_line(startVector + Vector2.LEFT * grid_offset_x, startVector + Vector2.RIGHT * grid_offset_x, horizontalColor, line_width / camera.zoom.x, true)
	
