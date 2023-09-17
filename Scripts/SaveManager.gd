extends Resource

class_name SaveManager


func save_graph(graph) -> void:
	var resource = graph.resources
	for point in graph.points:
		resource.points[point.global_position] = [point.handles[0].global_position, point.handles[1].global_position]
	ResourceSaver.save(resource, "res://graph.res")


func load_graph(path : String) -> Resource:
	return ResourceLoader.load(path)
