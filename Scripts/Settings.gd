extends PopupPanel


@export var window_mode : OptionButton
@export var graphs_directory : Button
@export var background_color : ColorPickerButton
@export var graph_directory_explorer : NativeFileDialog
@export_dir var settings_save_path := "res://settings.ini"
@export var keybinds : Array[Button]


func _ready():
	if FileAccess.file_exists(settings_save_path):
		load_settings()
	else:
		for keybind in keybinds:
			keybind.remap_key(InputMap.action_get_events(keybind.action)[0])

		save_settings()


func load_settings():
	Globals.settings = FileManager.load_data(settings_save_path)
	background_color_changed(Globals.settings.background_color)
	update_window_mode(Globals.settings.window_mode)
	window_mode.select(Globals.settings.window_mode)
	update_graphs_directory(Globals.settings.graphs_directory)
	
	for keybind in keybinds:
		keybind.remap_key(Globals.settings.get(keybind.keybind_name))


func save_settings():
	FileManager.save_data(Globals.settings, settings_save_path)


func background_color_changed(color):
	RenderingServer.set_default_clear_color(color)
	Globals.settings.background_color = color


func update_window_mode(index):
	Globals.settings.window_mode = index
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
	Globals.settings.graphs_directory = path
	graphs_directory.text = path
