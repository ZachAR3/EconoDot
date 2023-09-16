extends Node2D


@onready var graphs_list : ItemList = %GraphsList
@onready var selected_graph : int = Globals.selected_graph


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_graph():
#	Adds our new graph to the list and to our global graphs dictionary and initializing the points list
	Globals.graphs[graphs_list.add_item("New graph")] = Graph.new()


func remove_graph():
	if selected_graph:
		graphs_list.remove_item(selected_graph)


func item_selected(index):
	selected_graph = index
