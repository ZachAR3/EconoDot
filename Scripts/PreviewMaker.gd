extends Control


var points
var remapped_points
var graph
var drawing_size

@export var preview : Control
@export var preview_container : SubViewportContainer
@export var padding := 5.0

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


func remap_points():
#	Calculate the aspect ratios and scaling required
	var source_size := Vector2(float(abs(drawing_size[0]) + abs(drawing_size[1])), float(abs(drawing_size[2]) + abs(drawing_size[3])))
	var source_aspect_ratio = source_size.x/source_size.y
	var new_aspect_ratio := float(preview_container.size.x) / preview_container.size.y
	var new_scale : Vector2
	
	if new_aspect_ratio > source_aspect_ratio:
		new_scale = Vector2(source_size.x * (preview_container.size.y / source_size.y), preview_container.size.y)
	else:
		new_scale = Vector2(preview_container.size.x, source_size.y * (preview_container.size.x / source_size.x))
		
	# TODO potentially fix the scaling breaking if setting X min size
	preview.custom_minimum_size.y = new_scale.y
	
#	Fit the points into our new mapped and aspect correct container 
	remapped_points = points.duplicate()
	for point in range(len(remapped_points)):
		remapped_points[point].x = remap(remapped_points[point].x, drawing_size[1], drawing_size[0], padding, new_scale.x - padding)
		remapped_points[point].y = remap(remapped_points[point].y, drawing_size[3], drawing_size[2], padding, new_scale.y - padding)


func _draw():
	if points:
		remap_points()
		draw_polyline(remapped_points, graph.color, graph.width, true)

