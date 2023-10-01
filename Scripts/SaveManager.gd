extends Resource

class_name SaveManager


static func save_graph(graph, path : String) -> void:
	var data = graph.resources
	for point in graph.points:
		if path.get_extension() != ".ed":
			path = path.get_basename() + ".ed"
		
		# Vec 2 position = [handles 1, handles 2, handles enabled]
		data.points[point.global_position] = [point.handles[0].position, point.handles[1].position, point.handles_enabled]
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(var_to_str(data))


static func load_graph(path : String) -> Resource:
	return FileManager.load_data(path)
