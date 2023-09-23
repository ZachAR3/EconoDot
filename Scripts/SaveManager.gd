extends Resource

class_name SaveManager


static func save_graph(graph, location) -> void:
	var resource = graph.resources
	for point in graph.points:
		resource.points[point.global_position] = [point.handles[0].global_position, point.handles[1].global_position, point.handles_enabled]
	ResourceSaver.save(resource, location)


static func load_graph(path : String) -> Resource:
	return ResourceLoader.load(path)
