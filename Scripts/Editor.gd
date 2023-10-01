extends Node2D


@export var settings_popup : PopupPanel
@export var main_camera : Camera2D

@onready var graphs_explorer = %GraphsPreview
@onready var graphs_list = %GraphsList
@onready var graph_visualizer = %GraphVisualizer
@onready var save_manager = SaveManager.new()

@export var graph_item_scene : PackedScene
@export var label_scene : PackedScene
@export var open_dialog : NativeFileDialog
@export var save_dialog : NativeFileDialog

@export_group("Export menu")
@export var export_popup : PopupPanel
@export var start_x : SpinBox
@export var start_y : SpinBox
@export var width : SpinBox
@export var height : SpinBox


func _ready():
	get_tree().get_root().files_dropped.connect(file_dropped)

func export_graph():
	if len(Globals.graphs) > 0:
		var start_pos := Vector2(start_x.value, start_y.value)
		var original_pos = main_camera.global_position
		var original_size = get_viewport().size
		var size := Vector2(width.value, height.value)
		size = size if size != Vector2.ZERO else original_size
		get_viewport().size = size
		main_camera.position = start_pos
		main_camera.camera_moved.emit()
		%UI.visible = false
		export_popup.visible = false
		await get_tree().process_frame
		await get_tree().process_frame
		get_viewport().get_texture().get_image().save_png("res://test.png")
		%UI.visible = true
		main_camera.position = original_pos
		get_viewport().size = original_size


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


func add_label():
	var label = label_scene.instantiate()
	graph_visualizer.add_child(label)


func remove_label():
	if is_instance_valid(Globals.selected_item) && Globals.selected_item is DraggableControl:
		Globals.selected_item.queue_free()


func file_dropped(files : PackedStringArray) -> void:
	var file_path = files[0]
	if file_path.get_extension() == "ed":
		load_graph(file_path)
	


func open_settings():
	settings_popup.popup_centered()


func quit():
	get_tree().quit()
