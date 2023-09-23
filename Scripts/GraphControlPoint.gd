extends Draggable2D


@export var handles : Array[Area2D]

var handles_enabled = false

signal delete_control(control)


func _unhandled_input(event):
	super(event)
	
	if event.is_action_pressed("Delete") && hovered:
		delete_control.emit(self)
	if !hovered && event.is_action_pressed("Select") && !handles.any(func(handle) : return handle.hovered):
		toggle_handles(false)


func move(new_position : Vector2):
	global_position = new_position #+ mouse_offset
	moved.emit()


func selection_updated(currently_selected : bool):
	if currently_selected:
		#Globals.selected_item = self
		toggle_handles(true)


func toggle_handles(enabled : bool):
	for handle in handles:
		handle.visible = enabled


func handle_moved():
	handles_enabled = handles.any(func(handle) : return handle.enabled)
	moved.emit()


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false

