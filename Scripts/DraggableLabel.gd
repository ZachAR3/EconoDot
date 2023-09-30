extends DraggableControl

@export var line_edit : LineEdit

var double_click_threshold := 0.2
var last_click_time = 0


func _ready():
	super()
	pivot_offset = (size / 2)


func selection_updated(selected := false):
	pivot_offset = (size / 2)
	super(selected)
	if selected:
		Globals.selected_item = self
		if last_click_time >= (Time.get_ticks_msec() / 1000) - double_click_threshold:
			line_edit.editable = true
		last_click_time = Time.get_ticks_msec() / 1000
	else:
		line_edit.editable = false


func move(new_pos : Vector2) -> void:
	global_position = new_pos - pivot_offset

