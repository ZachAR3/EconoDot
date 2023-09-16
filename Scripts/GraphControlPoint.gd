extends CharacterBody2D

@export var mouse_follow_speed := Vector2(100.0, 100.0)
@export var handles : Array[Area2D]

var hovered := false
var grabbed = false
var mouse_offset := Vector2.ZERO


func _ready():
	pass # Replace with function body.


func _process(delta):
	# Add in the mouse offset when selecting instead of snapping the objects origin to it
	var mouse_position = get_global_mouse_position()
	if !grabbed:
		mouse_offset = Vector2(global_position.x - mouse_position.x, global_position.y - mouse_position.y)
	
	# Check if object is currently grabbed
	#grabbed = Input.is_action_pressed("Select") && (hovered or grabbed)
	if hovered && Input.is_action_just_pressed("Select") && !grabbed:
		grabbed = true
		selection_updated(true)
	if Input.is_action_just_released("Select"):
		grabbed = false
	if !hovered && Input.is_action_just_pressed("Select") && !handles.any(func(handle) : return handle.hovered):
		selection_updated(false)

	# Move the control point along with the mouse if grabbed
	if grabbed:
		velocity = ((mouse_position + mouse_offset) - global_position) * mouse_follow_speed
		move_and_slide()


func selection_updated(currently_selected):
	for handle in handles:
		handle.visible = currently_selected


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false

