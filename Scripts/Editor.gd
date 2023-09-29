extends Node2D


@onready var graphs_explorer = %GraphsPreview
@onready var graphs_list = %GraphsList
@onready var graph_visualizer = %GraphVisualizer
@onready var save_manager = SaveManager.new()

@export var graph_item_scene : PackedScene
@export var open_dialog : NativeFileDialog
@export var save_dialog : NativeFileDialog

@export_group("Export menu")
@export var export_popup : PopupPanel
@export var start_x : SpinBox
@export var start_y : SpinBox
@export var width : SpinBox
@export var height : SpinBox


func export_graph():
	if len(Globals.graphs) > 0:
		var start_pos := Vector2(start_x.value, start_y.value)
		var size := Vector2(width.value, height.value)
		%UI.visible = false
		export_popup.visible = false
		await get_tree().process_frame
		await get_tree().process_frame
		#get_viewport().get_preview(Vector2(500, 500))
		var viewport_transform = get_viewport_transform().origin
		print(size.x)
		#get_viewport().get_texture().get_image().get_region(Rect2i(start_pos.x + viewport_transform.x, start_pos.y + viewport_transform.y, viewport_transform.x + end_pos.x, DisplayServer.window_get_size().y -(viewport_transform.y + end_pos.y))).save_png("res://test.png")
		get_viewport().get_texture().get_image().get_region(Rect2i(viewport_transform.x + start_pos.x, viewport_transform.y - start_pos.y, size.x, size.y)).save_png("res://test.png")
		%UI.visible = true


func save_graph(location : String) -> void:
	save_manager.save_graph(Globals.graphs[Globals.selected_graph], location)


func load_graph(graph_path : String, graph_object : GraphResource = GraphResource.new()):
	var loaded_graph_resources = save_manager.load_graph(graph_path) if !graph_path.is_empty() else graph_object
	# Adds a new graph item to house the loaded points
	Globals.selected_graph = add_graph(loaded_graph_resources)
	# Adds all points from given resource
	for point in loaded_graph_resources.points:
		var new_point = graph_visualizer.add_point(point)
		new_point.handles[0].global_position = loaded_graph_resources.points[point][0]
		new_point.handles[1].global_position = loaded_graph_resources.points[point][1]
		new_point.handles_enabled = loaded_graph_resources.points[point][2]
		graph_visualizer.update_curve()


func add_graph(graph_resources := GraphResource.new()) -> int:
#	Adds our new graph to the list and to our global graphs dictionary and initializing the points list
	var graph = graph_item_scene.instantiate()
	# A bit unecessary... TODO if changing back to grabbing by name or giving it as an exported variable
	Globals.get_first_in_group(graph, "Item").item_selected.connect(item_selected)
	var new_graph = Graph.new()
	new_graph.resources = graph_resources
	graph_visualizer.add_child(new_graph)
	var index = graphs_list.add_item(graph_resources.name, graph)
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


func _load_graph_pressed():
	open_dialog.show()


func _save_graph_pressed():
	if Globals.selected_graph != -1:
		save_dialog.show()


func export_pressed():
	export_popup.popup_centered()
