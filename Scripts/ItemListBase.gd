extends Container


class_name ItemListBase

var items = []

signal item_selected_signal(index : int)


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
