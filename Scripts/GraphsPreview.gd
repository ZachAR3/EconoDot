extends ItemListBase


@export var editor : Node2D
@export var premade_graphs : Array[PackedScene]
#@export var graph_preview_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	for premade_graph in premade_graphs:
		var graph = premade_graph.instantiate()#
		#graph_preview.graph = premade_graph
		add_item("New graph", graph)


func _double_clicked(index : int):
	editor.load_graph("", items[index].graph)
