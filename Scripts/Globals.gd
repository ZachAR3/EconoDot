extends Node


var graphs = []
var selected_graph = -1

# Colors
var primary = Color('#75b9be')
var secondary = Color('#FE7F2D')
var trimary = Color('#FCCA46')
var quadrary = Color('#A1C181')
var quintupulary = Color('#619B8A')


func snap(snap_position : Vector2, current_position : Vector2, snap_threshold : int) -> Vector2:
	var snapped_position := current_position
	
	if abs(current_position.x - snap_position.x) < snap_threshold:
		snapped_position.x = snap_position.x
	if abs(current_position.y - snap_position.y) < snap_threshold:
		snapped_position.y = snap_position.y
	return snapped_position


func get_first_in_group(node, group_name):
	return node.get_children().filter(func(child): return group_name in child.get_groups()).front()
