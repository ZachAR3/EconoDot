extends CollisionObject2D

class_name Draggable2D


@export var snap := true
@export var snap_threshold := 10.0
@export var snap_offset := Vector2.ZERO

var hovered := false
var grabbed := false
		
var mouse_offset : Vector2

signal moved


func _ready():
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _unhandled_input(event):
	if event.is_action_pressed("Select"):
		var other_selected = (is_instance_valid(Globals.selected_item) && Globals.selected_item != self && global_position.distance_to(Globals.selected_item.global_position) < 10)
		grabbed = hovered && !grabbed && !other_selected
		selection_updated(hovered && !other_selected)
	if event.is_action_released("Select"):
		grabbed = false
	if event is InputEventMouseMotion:
		if grabbed:
			follow_mouse()
		else:
			var mouse_pos = get_global_mouse_position()
			mouse_offset = Vector2(global_position.x - mouse_pos.x, global_position.y - mouse_pos.y)


func follow_mouse():
	var target_position = get_global_mouse_position() + mouse_offset
	target_position = Globals.snap(target_position + snap_offset, snap_threshold) if snap else target_position
	
	move(target_position - snap_offset)


func move(new_position : Vector2):
	# Meant to be overrode with movement code
	pass


# Added for functions which need to know when grabbed is updated
func selection_updated(selected : bool):
#	Serves as an override to be used off of
	pass


func _mouse_entered():
	hovered = true


func _mouse_exited():
	hovered = false

