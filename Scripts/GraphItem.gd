extends LineEdit


func _double_clicked(index : int):
	editable = true


func _on_text_submitted(new_text):
	editable = false


func _lost_focus():
	editable = false
