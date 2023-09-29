extends PanelContainer

@export_group("Graph")
@export var x_coords : SpinBox
@export var y_coords : SpinBox

@export_group("Grid")
@export var horizontal_gap : SpinBox
@export var vertical_gap : SpinBox

@export_group("Axis")
@export var horizontal_offset : SpinBox
@export var vertical_offset : SpinBox
#@export var x_grid_color : ColorPickerButton
#@export var y_grid_color : ColorPickerButton


func _ready():
	%GraphVisualizer.curve_updated.connect(curve_updated)
	grid_gap_updated()


# Graph options
func curve_updated():
	if is_instance_valid(Globals.selected_item):
#		Used to prevent infinite recursion from updating calling move calling updating 
		x_coords.set_block_signals(true)
		y_coords.set_block_signals(true)
		
		x_coords.value = Globals.selected_item.global_position.x
		y_coords.value = -Globals.selected_item.global_position.y
		
		x_coords.set_block_signals(false)
		y_coords.set_block_signals(false)


func coordinates_updated():
	if is_instance_valid(Globals.selected_item):
		Globals.selected_item.move(Vector2(x_coords.value, -y_coords.value))


func graph_color_updated(color : Color):
	if Globals.selected_graph > -1:
		Globals.graphs[Globals.selected_graph].resources.color = color
		%GraphVisualizer.update_curve()


func graph_thickness_updated(thickness : float):
	if Globals.selected_graph > -1:
		Globals.graphs[Globals.selected_graph].resources.width = thickness
		%GraphVisualizer.update_curve()


# Grid options
func grid_gap_updated():
	%Grid.horizontal_gap = horizontal_gap.value
	%Grid.vertical_gap = vertical_gap.value
	%Grid.queue_redraw()


func horizontal_grid_color_updated(color : Color):
	%Grid.horizontalColor = color
	%Grid.queue_redraw()


func vertical_grid_color_updated(color : Color):
	%Grid.verticalColor = color
	%Grid.queue_redraw()


func grid_thickness_updated(thickness : float):
	%Grid.line_width = thickness
	%Grid.queue_redraw()


func horizontal_grid_enabled(enabled : bool):
	%Grid.draw_horizontal = enabled
	%Grid.queue_redraw()


func vertical_grid_enabled(enabled : bool):
	%Grid.draw_vertical = enabled
	%Grid.queue_redraw()


# Axis
func axis_gap_updated():
	%Axis.position_vector.x = horizontal_offset.value
	%Axis.position_vector.y = vertical_offset.value
	%Axis.queue_redraw()


func horizontal_axis_color_updated(color : Color):
	%Axis.horizontalColor = color
	%Axis.queue_redraw()


func vertical_axis_color_updated(color : Color):
	%Axis.verticalColor = color
	%Axis.queue_redraw()


func axis_thickness_updated(thickness : float):
	%Axis.line_width = thickness
	%Axis.queue_redraw()


func horizontal_axis_enabled(enabled : bool):
	%Axis.draw_horizontal = enabled
	%Axis.queue_redraw()


func vertical_axis_enabled(enabled : bool):
	%Axis.draw_vertical = enabled
	%Axis.queue_redraw()
