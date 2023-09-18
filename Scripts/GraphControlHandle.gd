extends Draggable

@export var oppisite_handle : Area2D
@export var start_offset := Vector2(30, 0)


func _ready():
	super()
	position += start_offset


func _unhandled_input(event):
	super(event)


func move(new_position : Vector2):
	global_position = new_position
	oppisite_handle.position = -position
	oppisite_handle.queue_redraw()
	queue_redraw()


func _draw():
	draw_line(Vector2.ZERO, oppisite_handle.position, Globals.trimary, 1, true)


