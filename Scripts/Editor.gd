extends Node2D


@onready var graphs_list = %GraphsList
@onready var graph_visualizer = %GraphVisualizer
@onready var save_manager = SaveManager.new()

@export var itemScene : PackedScene


#func _input(event):
#	if event is InputEventKey:
#		if event.is_action_pressed("ui_accept"):
#			load_graph("res://graph.res")


func load_graph(graph_path : String):
	var loaded_graph_resources = save_manager.load_graph(graph_path)
	# Adds a new graph item to house the loaded points
	Globals.selected_graph = add_graph()
	# Adds all points from given resource
	for point in loaded_graph_resources.points:
		var new_point = graph_visualizer.add_point(point)
		new_point.handles[0].global_position = loaded_graph_resources.points[point][0]
		new_point.handles[1].global_position = loaded_graph_resources.points[point][1]


func add_graph() -> int:
#	Adds our new graph to the list and to our global graphs dictionary and initializing the points list
	var item = itemScene.instantiate()
	item.selected.connect(item_selected)
	var new_graph = Graph.new()
	graph_visualizer.add_child(new_graph)
	var index = graphs_list.add_item("New graph", item)
	Globals.graphs.insert(index, new_graph)
	return index


func remove_graph():
	# Checks if our graph is valid within the list
	if Globals.selected_graph >= max(Globals.graphs.size() -1, 0):
		for point in Globals.graphs[Globals.selected_graph].points.duplicate():
			graph_visualizer.remove_point(point)
			
		# Removes the Graph class orphan
		Globals.graphs[Globals.selected_graph].queue_free()
		graphs_list.remove_item(Globals.selected_graph)
		Globals.graphs.remove_at(Globals.selected_graph)
		# Set to avoid index errors
		Globals.selected_graph = -1
	else:
		print("cannot find graph at index:", Globals.selected_graph)


func item_selected(index):
	Globals.selected_graph = index
