extends Node


var graphs := []
var selected_graph := -1
var selected_item
# = [[axis or pos, position (Vector2)]
var snappable_axis : Array[AxisResource] = []

# Colors
var primary = Color('#75b9be')
var secondary = Color('#FE7F2D')
var trimary = Color('#FCCA46')
var quadrary = Color('#A1C181')
var quintupulary = Color('#619B8A')


func snap(current_position : Vector2, snap_threshold : int) -> Vector2:
	var snapped_position := current_position
	
	for snappable in snappable_axis:
		var snap_position := snappable.axis_position
		# Snapping for single points
		if !snappable.horizontal_axis && !snappable.vertical_axis:
			if (current_position.distance_to(snap_position) < snap_threshold):
				snapped_position = snap_position
		else:
			#Snapping for axis'
			#Snap to Y axis
			if abs(current_position.x - snap_position.x) < snap_threshold * int(snappable.vertical_axis):
				snapped_position.x = snap_position.x
			#Snap to X axis
			if abs(current_position.y - snap_position.y) < snap_threshold * int(snappable.horizontal_axis):
				snapped_position.y = snap_position.y
	return snapped_position


func get_first_in_group(node, group_name):
	return node.get_children().filter(func(child): return group_name in child.get_groups()).front()
