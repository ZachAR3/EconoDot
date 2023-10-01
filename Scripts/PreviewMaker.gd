extends Control


var points
var final_points
var graph
var drawing_size
var redraw = false

var last_call_time := 0.0

@export var preview : Control
@export var preview_container : SubViewportContainer
@export var padding := 5.0


func _ready():
	preview.get_parent().draw.connect(size_updated)


func get_preview():
	var graph_curve = Curve2D.new()
	for point in graph.points:
		var handles_enabled = graph.points[point][2]
		
		var handle_1 = int(handles_enabled) * graph.points[point][0]
		var handle_2 = int(handles_enabled) * graph.points[point][1]
		
		graph_curve.add_point(point, handle_1, handle_2)
	
	points = graph_curve.tessellate(5, 2)
	get_drawing_size()
	if len(points) > 1:
		queue_redraw()
		


func get_drawing_size():
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	for point in points:
		if point.x < min_x:
			min_x = point.x
		if point.x > max_x:
			max_x = point.x
		if point.y < min_y:
			min_y = point.y
		if point.y > max_y:
			max_y = point.y
	drawing_size = Vector4i(max_x, min_x, max_y, min_y)
	return drawing_size


func size_updated():
	final_points = await remap_points(points)


func remap_points(original_points = null) -> Array:
	# Infinite loop prevention
	var time = Time.get_ticks_msec()
	if time - last_call_time < 5:
		await get_tree().process_frame
		
	var container_size = preview.get_parent_area_size() / 2.05
	var source_size := Vector2(float(abs(drawing_size[0]) + abs(drawing_size[1])), float(abs(drawing_size[2]) + abs(drawing_size[3])))
	var source_aspect_ratio = source_size.x/source_size.y
	var new_aspect_ratio = 1.0
	var new_size : Vector2
	

	if new_aspect_ratio > source_aspect_ratio:
		new_size = Vector2(source_size.x * (container_size.x / source_size.y), container_size.x)
	else:
		new_size = Vector2(container_size.x, source_size.y * (container_size.x / source_size.x))
		

	preview.custom_minimum_size = new_size
	
#	Fit the points into our new mapped and aspect correct container 
	var remapped_points = original_points.duplicate()
	for point in range(len(remapped_points)):
		remapped_points[point].x = remap(remapped_points[point].x, drawing_size[1], max(drawing_size[0], graph.width), padding, new_size.x - padding)
		remapped_points[point].y = remap(remapped_points[point].y, drawing_size[3], max(drawing_size[2], graph.width), padding, new_size.y - padding)
	last_call_time = time
	return remapped_points


func _draw():
	if final_points:
		draw_polyline(final_points, graph.color, graph.width, true)

