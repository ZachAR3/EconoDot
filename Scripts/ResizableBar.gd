extends TextureButton

class_name ResizableBar


@export var root : Control
@export var max_size := 1.0
@export var min_size := 0.0
@export var anchor := SIDE_LEFT


func _ready():
	set_process(false)


func _process(delta):
	drag()


func _gui_input(event):
	if event.is_action("Select"):
		set_process(true)
	if event.is_action_released("Select"):
		set_process(false)


func drag():
	var screen_size = DisplayServer.window_get_size()
	var new_anchor : float = clamp(abs(get_global_mouse_position().x / screen_size.x), min_size, max_size)
	match anchor:
		SIDE_LEFT:
			root.anchor_left = new_anchor
		SIDE_TOP:
			root.anchor_top = new_anchor
		SIDE_RIGHT:
			root.anchor_right = new_anchor
		SIDE_BOTTOM:
			root.anchor_bottom = new_anchor
