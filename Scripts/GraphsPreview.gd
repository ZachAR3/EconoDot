extends ItemListBase


@export var editor : Node2D
@export_dir var premade_graphs : String
@export var graph_preview_scene : PackedScene

var previews := []


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()


func refresh():
	var graphs_directory = DirAccess.open(premade_graphs)
	for graph_file in graphs_directory.get_files():
		# TODO #17 (Fix crappy path grabbing)
		var graph_resource = FileManager.load_data(graphs_directory.get_current_dir() + "/" + graph_file)
		
		if previews.has(graph_resource.points):
			continue
			
		var graph = graph_preview_scene.instantiate()
		graph.graph = graph_resource
		
		add_item(graph.graph.name, graph)
		previews.append(graph_resource.points)


func _double_clicked(index : int):
	editor.load_graph("", items[index].graph)
