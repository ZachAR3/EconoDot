extends Draggable2D


@export var handles : Array[Area2D]

signal delete_control(control)


func _ready():
	super()


func _unhandled_input(event):
	super(event)
	
	if event.is_action_pressed("Delete") && hovered:
		delete_control.emit(self)
	if !hovered && event.is_action_pressed("Select") && !handles.any(func(handle) : return handle.hovered):
		selection_updated(false)


func move(new_position : Vector2):
	global_position = new_position #+ mouse_offset


func selection_updated(currently_selected : bool):
	super(currently_selected)
	for handle in handles:
		handle.visible = currently_selected


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false

