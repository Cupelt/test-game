extends RefCounted
class_name Stat

signal on_value_changed(old_value: float, new_value: float)

@export var base_value: float = 0: 
	set(value):
		base_value = value
		update_value()

var offset_value: float = 0:
	set(value):
		offset_value = value
		update_value()

var current_value: float = 0
var _modifiers: Dictionary = {}

func reset():
	offset_value = 0
	_modifiers = {}
	update_value()

func add_modifier(id: String, value: float) -> void:
	_modifiers[id] = value
	update_value()

func remove_modifier(id: String) -> void:
	if _modifiers.has(id):
		_modifiers.erase(id)
		update_value()

func update_value():
	var old_value = current_value
	
	current_value = base_value - offset_value
	if old_value != current_value:
		on_value_changed.emit(old_value, current_value)
