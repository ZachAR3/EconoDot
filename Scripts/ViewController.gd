extends Camera2D


const MIN_ZOOM := 0.1
const MAX_ZOOM := 10.0
const ZOOM_INCREMENT := 0.1
const ZOOM_RATE := 8.0

var target_zoom := 1.0


func _physics_process(delta) -> void:
	zoom = lerp(
		zoom,
		target_zoom * Vector2.ONE,
		ZOOM_RATE * delta
	)
	set_physics_process(!is_equal_approx(zoom.x, target_zoom))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
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
