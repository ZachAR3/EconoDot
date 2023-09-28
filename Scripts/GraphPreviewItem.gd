extends Control


@export_file("*.ed") var graph_path : String
@export var preview_maker : Control

var graph

signal add_graph (GraphResource)


func _ready():
	preview_maker.graph = graph
	preview_maker.get_preview()
	


func _add_graph(graph_index : int):
	add_graph.emit(graph)


# TODO #13 (Draggable graphs onto scene)
#func move(new_position : Vector2):
#	global_position = new_position

