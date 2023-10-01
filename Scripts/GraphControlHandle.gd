extends Draggable2D

@export var opposite_handle : Area2D
@export var start_offset := Vector2(30, 0)
@export var enabled := false
@export var line_color : Color


func _ready():
	super()
	position += start_offset


func _unhandled_input(event):
	super(event)
	if hovered && event.is_action_pressed("Delete"):
		enabled = false
		moved.emit()


func selection_updated(selected : bool):
	if selected:
		Globals.selected_item = self


func move(new_position : Vector2):
	enabled = true
	global_position = new_position
	#opposite_handle.position = -position
	
	moved.emit()
	
	opposite_handle.queue_redraw()
	queue_redraw()


func _draw():
	draw_line(Vector2.ZERO, opposite_handle.position, line_color, 1, true)


