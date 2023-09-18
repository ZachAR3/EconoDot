extends CollisionObject2D

class_name Draggable


@export var snap := true
@export var snap_threshold := 10.0
@export var snap_position := Vector2.ZERO

var hovered := false
var grabbed := false : 
	set (value):
		grabbed = value
		grabbed_updated(value)
	get:
		return grabbed
		
var mouse_offset : Vector2
var mouse_position : Vector2


func _ready():
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _unhandled_input(event):
	if event.is_action_pressed("Select"):
		grabbed = hovered && !grabbed
	if event.is_action_released("Select"):
		grabbed = false
	if event is InputEventMouseMotion:
		mouse_position = event.global_position
		if grabbed:
			follow_mouse()
			queue_redraw()
		else:
			mouse_offset = Vector2(global_position.x - mouse_position.x, global_position.y - mouse_position.y)


func follow_mouse():
	if !grabbed:
		mouse_offset = Vector2(global_position.x - mouse_position.x, global_position.y - mouse_position.y)
		
	var target_position = mouse_position + mouse_offset
	target_position = Globals.snap(snap_position, target_position, snap_threshold) if snap else target_position
	
	move(target_position)


func move(new_position : Vector2):
	# Meant to be overrode with movement code
	pass


# Added for functions which need to know when grabbed is updated
func grabbed_updated(_grabbed : bool):
	pass


func _mouse_entered():
	print("HI")
	hovered = true


func _mouse_exited():
	hovered = false
