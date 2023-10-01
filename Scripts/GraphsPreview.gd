extends ItemListBase


@export var editor : Node2D
@export var graph_preview_scene : PackedScene

var previews := []


func _ready():
	refresh()


func refresh():
	var graphs_directory = DirAccess.open(Globals.settings.graphs_directory)
	for graph_file in graphs_directory.get_files():
		if graph_file.get_extension() != "ed":
			continue
			
		var graph_resource = FileManager.load_data(graphs_directory.get_current_dir() + "/" + graph_file)
		
		if previews.has(graph_resource.points):
			continue
			
		var graph = graph_preview_scene.instantiate()
		graph.graph = graph_resource
		
		add_item(graph.graph.name, graph)
		previews.append(graph_resource.points)
		queue_redraw()


func _double_clicked(index : int):
	editor.load_graph("", items[index].graph)
