extends Button


@export var action : String


func _ready():
	#set_process_unhandled_key_input(false)
	set_process_unhandled_input(false)
	display_key()


func display_key():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()


func _button_toggled(enabled):
	set_process_unhandled_input(enabled)
	if enabled:
		text = "..."
	else:
		display_key()


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		return
	remap_key(event)
	button_pressed = false


func remap_key(event):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	
	text = "%s" % event.as_text()
