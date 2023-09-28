extends ItemListBase


@export var editor : Node2D
@export_dir var premade_graphs : String
@export var graph_preview_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	var graphs_directory = DirAccess.open(premade_graphs)
	# TODO #17 (Fix crappy path grabbing)
	for graph_file in graphs_directory.get_files():
		var graph = graph_preview_scene.instantiate()
		graph.graph = FileManager.load_data(graphs_directory.get_current_dir() + "/" + graph_file)
		add_item("New graph", graph)


func _double_clicked(index : int):
	editor.load_graph("", items[index].graph)
