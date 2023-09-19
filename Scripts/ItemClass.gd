extends Control

class_name Item


var index : int
var double_click_threshold := 0.2
var last_click_time = 0

signal item_selected(int)
signal double_clicked(int)


func _gui_input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("Select"):
			selection_updated()

func selection_updated(_selected := true):
	item_selected.emit(index)
	
	if last_click_time >= (Time.get_ticks_msec() / 1000) - double_click_threshold:
		double_clicked.emit(index)
	last_click_time = Time.get_ticks_msec() / 1000



