extends Area2D

@export var oppisite_handle : Area2D
@export var start_offset := Vector2(30, 0)

var hovered := false
var grabbed = false
var mouse_offset := Vector2.ZERO


func _ready():
	position += start_offset


func _process(delta):
	# Add in the mouse offset when selecting instead of snapping the objects origin to it
	var mouse_position = get_global_mouse_position()
	if !grabbed:
		mouse_offset = Vector2(global_position.x - mouse_position.x, global_position.y - mouse_position.y)
	
	# Check if object is currently grabbed
	#grabbed = Input.is_action_pressed("Select") && (hovered or grabbed)
	if hovered && Input.is_action_just_pressed("Select") && !grabbed:
		grabbed = true
	if Input.is_action_just_released("Select"):
		grabbed = false

	# Move the control point along with the mouse if grabbed
	if grabbed:
		global_position = mouse_position + mouse_offset
		oppisite_handle.position = -position
		oppisite_handle.queue_redraw()
		queue_redraw()


func _draw():
	draw_line(Vector2.ZERO, oppisite_handle.position, Color.RED, 1, true)


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false

