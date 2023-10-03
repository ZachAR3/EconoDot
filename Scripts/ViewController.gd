extends Camera2D


const MIN_ZOOM := 0.1
const MAX_ZOOM := 10.0
const ZOOM_INCREMENT := 0.1
const ZOOM_RATE := 8.0

var target_zoom := 1.0

var panning := false

signal camera_moved


func _physics_process(delta) -> void:
	zoom = lerp(
		zoom,
		target_zoom * Vector2.ONE,
		ZOOM_RATE * delta
	)
	set_physics_process(!is_equal_approx(zoom.x, target_zoom))
	
	camera_moved.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pan"):
		panning = true
	if event.is_action_released("Pan"):
		panning = false
	if event is InputEventMouseMotion:
		if panning:
			camera_moved.emit()
			position -= event.relative / zoom
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_out()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_in()


func zoom_in():
	target_zoom = max(target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)


func zoom_out():
	target_zoom = min(target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
