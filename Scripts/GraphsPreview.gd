extends ItemListBase


@export var editor : Node2D
@export var premade_graphs : Array[GraphResource]
@export var graph_preview_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	for premade_graph in premade_graphs:
		print(premade_graph.points)
		var graph_preview = graph_preview_scene.instantiate()
		graph_preview.get_child(0).graph = premade_graph
		add_item("New graph", graph_preview)


func _double_clicked(index : int):
	editor.load_graph("", items[index].get_child(0).graph)
