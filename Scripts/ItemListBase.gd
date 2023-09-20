extends Container


class_name ItemListBase

@export var item_group : String

var items = []

signal item_selected(index : int)
signal double_clicked()


func is_item_in_group(object, group):
	return group in object.get_groups()


func add_item(text : String, item_object, index := -1) -> int:
	var item_info = Globals.get_first_in_group(item_object, item_group)
	if index == -1:
		items.append(item_object)
		item_info.index = max(len(items) -1, 0)
	else:
		items.insert(index, item_object)
		item_info.index = index
		# TODO
		var object_index = index
		while object_index < len(items):
			#TODO
			#items[object_index].index += 1
			object_index += 1
	add_child(item_object)
	item_info.item_selected.connect(_item_selected)
	item_info.double_clicked.connect(_double_clicked)
	return item_info.index


func remove_item(index : int):
	if len(items) <= index:
		return
	
	# Update object indexes (TODO)
	var object_index = index
	while object_index < len(items):
		Globals.get_first_in_group(items[object_index], item_group).index -= 1
		object_index += 1
	
	items[index].queue_free()
	items.remove_at(index)


func _item_selected(index : int):
	item_selected.emit(index)


func _double_clicked(index : int):
	double_clicked.emit(index)
