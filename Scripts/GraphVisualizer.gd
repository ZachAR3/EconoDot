extends Node2D


@export var control_point_scene: PackedScene

var mode
var mouse_offset := Vector2.ZERO

enum {
	ADD,
	EDIT,
	MOVE
}


func _process(_delta):
	# TODO make it so it only updates be points are added or edited
	match mode:
		MOVE:
			move()
	#update_curve()


func _unhandled_input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("Select"):
			if mode == MOVE:
				mode = EDIT
				
			match mode:
				ADD:
					add_point()
	elif event is InputEventKey:
		if event.is_action_pressed("AddMode"):
			mode = ADD
		elif event.is_action_pressed("EditMode"):
			mode = EDIT
		elif event.is_action_pressed("Move"):
			mode = MOVE
			var mouse_position = get_global_mouse_position()
			mouse_offset = Vector2(Globals.graphs[Globals.selected_graph].position.x - mouse_position.x, Globals.graphs[Globals.selected_graph].position.y - mouse_position.y)


func _draw():
	for graph in Globals.graphs:
		var points = graph.curve.tessellate(5, 2)
		if len(points) > 1:
			draw_polyline(points, graph.resources.color, graph.resources.width, true)


func update_curve():
	# TODO
	for graph in Globals.graphs:
		graph.curve.clear_points()
		for point in graph.points:
			var handle_1 = int(point.handles_enabled) * point.handles[0].position
			var handle_2 = int(point.handles_enabled) * point.handles[1].position
			
			graph.curve.add_point(point.global_position, handle_1, handle_2)
	queue_redraw()


func add_point(point_position := Vector2.INF):
	if Globals.selected_graph == -1:
		print("no graph selected")
		return
	var point = control_point_scene.instantiate()
	var point_index = -1
	var closest_point
		
	Globals.graphs[Globals.selected_graph].add_child(point)
	point.delete_control.connect(remove_point)
	if point_position == Vector2.INF:
		point.global_position = get_global_mouse_position()
	else:
		point.global_position = point_position
	
	point.moved.connect(update_curve)
	
	Globals.graphs[Globals.selected_graph].points.append(point)
	update_curve()
	
	return point


func remove_point(point):
	print("remove point")
	if point in Globals.graphs[Globals.selected_graph].points:
		Globals.graphs[Globals.selected_graph].points.erase(point)
		point.queue_free()
		update_curve()


func move():
	var mouse_position = get_global_mouse_position()
	var graph_position = Globals.graphs[Globals.selected_graph].global_position
	Globals.graphs[Globals.selected_graph].global_position = mouse_position + mouse_offset
	update_curve()
