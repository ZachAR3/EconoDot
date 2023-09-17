extends LineEdit


var index : int
var double_click_threshold := 0.2
var last_click_time = 0

signal selected(int)


func _on_gui_input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("Select"):
			on_selected()

func on_selected():
	selected.emit(index)
	
	if last_click_time >= (Time.get_ticks_msec() / 1000) - double_click_threshold:
		editable = true
	last_click_time = Time.get_ticks_msec() / 1000


func _on_text_submitted(new_text):
	editable = false


func lost_focus():
	editable = false


