extends Axis

@export var horizontal_gap := 50
@export var vertical_gap := 50

var grid_lines := []


func _ready():
	super()


func _draw():
	calculate_lines()
	for line in grid_lines:
		draw_screen_line(line.vertical_axis, line.axis_position)


func calculate_lines():
	var screen_size := DisplayServer.window_get_size()
	Globals.snappable_axis = Globals.snappable_axis.filter(func(snappable) : !grid_lines.has(snappable))
	grid_lines = []
	if draw_horizontal:
		var lower_bound = ((camera.global_position.y - (screen_size.y / camera.zoom.y)) / horizontal_gap)
		var upper_bound = (((screen_size.y / camera.zoom.y) + camera.global_position.y) / horizontal_gap)
		for horizontal_line in range(lower_bound, upper_bound):
			var line := AxisResource.new()
			line.vertical_axis = false
			line.horizontal_axis = true
			line.axis_position = Vector2(0, horizontal_line * horizontal_gap)
			grid_lines.append(line)
			Globals.snappable_axis.append(line)
	if draw_vertical:
		var lower_bound = ((camera.global_position.x - (screen_size.x / camera.zoom.x)) / vertical_gap)
		var upper_bound = (((screen_size.x / camera.zoom.x) + camera.global_position.x) / vertical_gap)
		for vertical_line in range(lower_bound, upper_bound):
			var line := AxisResource.new()
			line.vertical_axis = true
			line.horizontal_axis = false
			line.axis_position = Vector2(vertical_line * vertical_gap, 0)
			grid_lines.append(line)
			Globals.snappable_axis.append(line)
