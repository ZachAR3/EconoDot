extends Control

class_name DraggableControl


@export var snap := true
@export var snap_threshold := 10.0
@export var snap_offset := Vector2.ZERO

var hovered := false
var grabbed := false
		
var mouse_offset : Vector2
var mouse_position : Vector2

signal moved


func _ready():
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _gui_input(event):
	if event.is_action_pressed("Select"):
		grabbed = hovered && !grabbed
		selection_updated(hovered)
	if event.is_action_released("Select"):
		grabbed = false
	if event is InputEventMouseMotion:
		mouse_position = get_global_mouse_position()
		if grabbed:
			follow_mouse()
			queue_redraw()
		else:
			mouse_offset = Vector2(global_position.x - mouse_position.x, global_position.y - mouse_position.y) + pivot_offset.rotated(rotation)


func follow_mouse():
	var target_position = mouse_position + mouse_offset
	target_position = Globals.snap(target_position + snap_offset, snap_threshold) if snap else target_position
	
	move(target_position - snap_offset)


func move(new_position : Vector2):
	# Meant to be overrode with movement code
	global_position = new_position
	moved.emit()


# Added for functions which need to know when grabbed is updated
func selection_updated(selected : bool):
#	Serves as an override to be used off of
	Globals.selected_item = self


func _mouse_entered():
	hovered = true


func _mouse_exited():
	hovered = false

