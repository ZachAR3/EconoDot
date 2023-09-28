extends LineEdit


func _double_clicked(index : int):
	editable = true
	#var top_left = get_rect().position - get_rect().size
	var properties_position = get_screen_position()
	var rect_size = get_rect().size
	rect_size.y =  properties_position.y #+ DisplayServer.window_get_size(0).y
	properties_position.y += rect_size.y



func _on_text_submitted(new_text):
	editable = false
	Globals.graphs[Globals.selected_graph].resources.name = new_text


func _lost_focus():
	editable = false
