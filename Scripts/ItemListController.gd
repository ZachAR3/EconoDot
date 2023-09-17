extends VBoxContainer


var items = []

signal item_selected_signal(index : int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_item(text : String, item_object, index := -1) -> int:
	if index == -1:
		items.append(item_object)
		item_object.index = max(len(items) -1, 0)
	else:
		items.insert(index, item_object)
		item_object.index = index
		# TODO
		var object_index = index
		while object_index < len(items):
			items[object_index].index += 1
			object_index += 1
	add_child(item_object)
	item_object.selected.connect(item_selected)
	return item_object.index


func remove_item(index : int):
	if len(items) <= index:
		return
	
	# Update object indexes (TODO)
	var object_index = index
	while object_index < len(items):
		items[object_index].index -= 1
		object_index += 1
	
	items[index].queue_free()
	items.remove_at(index)


func item_selected(index : int):
	item_selected_signal.emit(index)
