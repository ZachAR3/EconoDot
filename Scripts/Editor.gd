extends Node2D


@onready var graphs_explorer = %GraphsPreview
@onready var graphs_list = %GraphsList
@onready var graph_visualizer = %GraphVisualizer
@onready var save_manager = SaveManager.new()

@export var graph_item_scene : PackedScene
@export var open_dialog : NativeFileDialog
@export var save_dialog : NativeFileDialog


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			save_dialog.show()
		if event.is_action_pressed("ui_cancel"):
			open_dialog.show()
			#save_manager.save_graph(Globals.graphs[Globals.selected_graph], file_dialog.)


func _process(delta):
	if is_instance_valid(Globals.selected_item):
		$UI/LineEdit.text = str(Globals.selected_item.global_position)


func save_graph(location : String) -> void:
	save_manager.save_graph(Globals.graphs[Globals.selected_graph], location)


func load_graph(graph_path : String, graph_object : GraphResource = GraphResource.new()):
	var loaded_graph_resources = save_manager.load_graph(graph_path) if !graph_path.is_empty() else graph_object
	# Adds a new graph item to house the loaded points
	Globals.selected_graph = add_graph(loaded_graph_resources.name)
	# Adds all points from given resource
	for point in loaded_graph_resources.points:
		var new_point = graph_visualizer.add_point(point)
		new_point.handles[0].global_position = loaded_graph_resources.points[point][0]
		new_point.handles[1].global_position = loaded_graph_resources.points[point][1]
		new_point.handles_enabled = loaded_graph_resources.points[point][2]
		graph_visualizer.update_curve()


func add_graph(title := "New graph") -> int:
#	Adds our new graph to the list and to our global graphs dictionary and initializing the points list
	var graph = graph_item_scene.instantiate()
	# A bit unecessary... TODO if changing back to grabbing by name or giving it as an exported variable
	Globals.get_first_in_group(graph, "Item").item_selected.connect(item_selected)
	var new_graph = Graph.new()
	#new_graph.text = title
	graph_visualizer.add_child(new_graph)
	var index = graphs_list.add_item(title, graph)
	Globals.graphs.insert(index, new_graph)
	return index


func remove_graph():
	# Checks if our graph is valid within the list
	if (0 <= Globals.selected_graph && Globals.selected_graph < Globals.graphs.size()):
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
