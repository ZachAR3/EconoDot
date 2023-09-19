extends Item


@export var graph := GraphResource

signal add_graph (GraphResource)


func _add_graph(graph_index : int):
	add_graph.emit(graph)


# TODO #13
#func move(new_position : Vector2):
#	global_position = new_position
