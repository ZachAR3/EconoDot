extends PopupPanel


@export var window_mode : OptionButton
@export var graphs_directory : Button
@export var background_color : ColorPickerButton
@export var graph_directory_explorer : NativeFileDialog


func _ready():
	graphs_directory.text = Globals.graphs_directory
	background_color_changed(background_color.color)


func background_color_changed(color):
	RenderingServer.set_default_clear_color(color)


func update_window_mode(index):
	var mode_id = window_mode.get_item_id(index)
#	If our mode is borderless window we want to set it to be windowed mode else use the ID mode
	if mode_id == 1:
		DisplayServer.window_set_mode(window_mode.get_item_id(MODE_MAXIMIZED))
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_mode(mode_id)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func update_graphs_directory_pressed():
	graph_directory_explorer.show()


func update_graphs_directory(path : String):
#	Cleanup
	%GraphsPreview.previews = []
	var preview_index = len(%GraphsPreview.items)
	while preview_index >= 0:
		%GraphsPreview.remove_item(preview_index)
		preview_index -= 1
		
#	Adding the newly selected path
	Globals.graphs_directory = path
	graphs_directory.text = path
