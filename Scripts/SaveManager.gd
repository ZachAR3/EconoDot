extends Resource

class_name SaveManager


static func save_graph(graph, location) -> void:
	var data = graph.resources
	for point in graph.points:
		data.points[point.global_position] = [point.handles[0].global_position, point.handles[1].global_position, point.handles_enabled]
	var file = FileAccess.open(location, FileAccess.WRITE)
	file.store_string(var_to_str(data))


static func load_graph(path : String) -> Resource:
	return FileManager.load_data(path)
