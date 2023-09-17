extends Node2D


@onready var graphs_list = %GraphsList
@onready var graph_visualizer = %GraphVisualizer

@export var itemScene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_graph():
#	Adds our new graph to the list and to our global graphs dictionary and initializing the points list
	var item = itemScene.instantiate()
	item.selected.connect(item_selected)
	var new_graph = Graph.new()
	graph_visualizer.add_child(new_graph)
	Globals.graphs[graphs_list.add_item("New graph", item)] = new_graph


func remove_graph():
	if Globals.selected_graph != -1:
		for point in Globals.graphs[Globals.selected_graph].points.duplicate():
			graph_visualizer.remove_point(point)
			
		# Removes the Graph class orphan
		Globals.graphs[Globals.selected_graph].queue_free()
		graphs_list.remove_item(Globals.selected_graph)
		Globals.graphs.erase(Globals.selected_graph)


func item_selected(index):
	Globals.selected_graph = index
