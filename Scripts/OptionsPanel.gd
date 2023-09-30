extends PanelContainer

@export_group("Graph")
@export var graph_container : VBoxContainer
@export var x_coords : SpinBox
@export var y_coords : SpinBox
@export var control_points_visible : CheckButton

@export_group("Grid")
@export var grid_container : VBoxContainer
@export var horizontal_gap : SpinBox
@export var vertical_gap : SpinBox

@export_group("Axis")
@export var axis_container : VBoxContainer
@export var horizontal_offset : SpinBox
@export var vertical_offset : SpinBox


func _ready():
	#TODO
	#%GraphVisualizer.curve_updated.connect(curve_updated)
	grid_gap_updated()


# UI Visibility
func graph_options_visible_toggled():
	graph_container.visible = !graph_container.visible


func grid_options_visible_toggled():
	grid_container.visible = !grid_container.visible


func axis_options_visible_toggled():
	axis_container.visible = !axis_container.visible


# Graph options
# TODO
#func curve_updated():
func _process(delta):
	if is_instance_valid(Globals.selected_item):
#		Used to prevent infinite recursion from updating calling move calling updating 
		x_coords.set_block_signals(true)
		y_coords.set_block_signals(true)

		var pivot = Globals.selected_item.pivot_offset.rotated(Globals.selected_item.rotation)
		x_coords.value = Globals.selected_item.global_position.x + pivot.x
		y_coords.value = -Globals.selected_item.global_position.y - pivot.y
		
		x_coords.set_block_signals(false)
		y_coords.set_block_signals(false)


func coordinates_updated():
	if is_instance_valid(Globals.selected_item):
		Globals.selected_item.move(Vector2(x_coords.value, y_coords.value))



func graph_color_updated(color : Color):
	if Globals.selected_graph > -1:
		Globals.graphs[Globals.selected_graph].resources.color = color
		%GraphVisualizer.update_curve()


func graph_thickness_updated(thickness : float):
	if Globals.selected_graph > -1:
		Globals.graphs[Globals.selected_graph].resources.width = thickness
		%GraphVisualizer.update_curve()


func show_control_points_toggled(points_visible):
	if Globals.selected_graph > -1:
		Globals.graphs[Globals.selected_graph].visible = points_visible


func graph_visibility_toggled(graph_visible):
	control_points_visible.button_pressed = graph_visible
	control_points_visible.disabled = !graph_visible
	if Globals.selected_graph > -1:
		Globals.graphs[Globals.selected_graph].resources.visible = graph_visible
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


func rotation_updated(new_rotation):
	if is_instance_valid(Globals.selected_item) && Globals.selected_item is DraggableControl:
		Globals.selected_item.rotation = deg_to_rad(new_rotation)
