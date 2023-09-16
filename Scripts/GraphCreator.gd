extends Node2D


@export var control_point_scene: PackedScene
@export var control_rod_length := 100

var graphs = {}
var curve = Curve2D.new()

enum {
	ADD,
	EDIT
}

var mode


func _process(_delta):
	# TODO make it so it only updates be points are added or edited
	update_curve()


func _unhandled_input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("Select"):
			match mode:
				ADD:
					add_point()
				EDIT:
					update_curve()
	elif event is InputEventKey:
		if event.is_action_pressed("AddMode"):
			mode = ADD
		elif event.is_action_pressed("EditMode"):
			mode = EDIT


func _draw():
	var points = curve.tessellate()

	if len(points) > 1:
		draw_polyline(points, Color.RED, 1, true)


func update_curve():
	curve.clear_points()
	# TODO
	if graphs.has('point'):
		for point in graphs['point']:
			var handle_1
			var handle_2
			
			if point.handles[0].position == point.handles[0].start_offset:
				handle_1 = Vector2.ZERO
			else:
				handle_1 = point.handles[0].position
			if point.handles[1].position == point.handles[1].start_offset:
				handle_2 = Vector2.ZERO
			else:
				handle_2 = point.handles[1].position
				
			curve.add_point(point.position, handle_1, handle_2)
	queue_redraw()


func add_point():
	var point = control_point_scene.instantiate()
	add_child(point)
	point.global_position = get_global_mouse_position()
	
	var point_index = -1
	var closest_point
	if !graphs.has('point'):
		graphs['point'] = []
	graphs['point'].append(point)
	update_curve()

#	Add the ability to make in-between points
#	if len(graphs['point']) > 1:
#		for point_t in graphs['point']:
#			if closest_point != null && (point.distance_to(point_t) < point.distance_to(closest_point)):
#				closest_point = point_t
#
#	point_index = graphs['point'].find(closest_point) + 1
#	curve.add_point(point.position, Vector2.ZERO, Vector2.ZERO, point_index)
#	graphs['point'].insert(point_index, point)
#
		



	
#	Old method with predertmined in/out based on slope
#	Add the midpoint as the second curve point with control vectors
#	var slope = abs((end_point.y - start_point.y) / (end_point.x - start_point.x))
#	var bezier_in = Vector2(control_rod_length, 0).rotated(atan(slope))
#	var bezier_out = Vector2(-control_rod_length, 0).rotated(atan(slope))

# Old method to manually create Bezier curves
#func create_bezier(start_point:Vector2, control_point:Vector2, end_point:Vector2, number_of_points:int):
#	var points = []
#	for point in number_of_points:
#		var point_position = remap(point, 0, number_of_points -1, 0, 1)
#		var s_point = start_point.lerp(control_point, point_position)
#		var e_point = control_point.lerp(end_point, point_position)
#		points.append(s_point.lerp(e_point, point_position))
#	return points

#	# Create an Expression from the formula
#	var input_names = PackedStringArray(["x"])
#	var expression = Expression.new()
#	var err = expression.parse("tan(x)", input_names)
#	if err != OK:
#		print("Error parsing the formula: ", err)
#		return
#
#	# Choose graph dimensions and scales:
#	# In pixels on screen
#	var pixel_xmin = 0.0
#	var pixel_xmax = 1000.0
#	var pixel_ymin = 1000.0 # in Godot 2D, Y axis points down, but we want up
#	var pixel_ymax = 0.0
#	# Graph area
#	var xmin = -4.0
#	var xmax = 4.0
#	var ymin = -4.0
#	var ymax = 4.0
#
#	var inputs = [0]
#	var prev_pixel_y = null
#
#	# For each pixel along the X axis
#	for pixel_x in range(pixel_xmin, pixel_xmax):
#		# Convert X to graph coordinates
#		var x = lerp(xmin, xmax, inverse_lerp(pixel_xmin, pixel_xmax, pixel_x))
#
#		# Execute expression
#		inputs[0] = x
#		var y = expression.execute(inputs)
#
#		if expression.has_execute_failed() or is_inf(y) or is_nan(y):
#			# Skip this point
#			prev_pixel_y = null
#			continue
#
#		# Convert Y to graph coordinates
#		var pixel_y = lerp(pixel_ymin, pixel_ymax, inverse_lerp(ymin, ymax, y))
#
#		if prev_pixel_y != null:
#			# Draw line if we have a previous value to connect to the current one
#			draw_line(
#				Vector2(pixel_x - 1, prev_pixel_y),
#				Vector2(pixel_x, pixel_y),
#				Color(1, 1, 0))
#
#		# Remember last value so we can draw a line in the next iteration
#		prev_pixel_y = pixel_y
