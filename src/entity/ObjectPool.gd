@abstract extends Node2D
class_name ObjectPool

static var pool: Dictionary[String, Array]

static func safe_destroy_object(obj: Node) -> void:
	obj.get_tree().process_frame.connect(
			func (): destroy_object(obj), 
			CONNECT_ONE_SHOT)

static func destroy_object(obj: Node) -> void:
	if obj.has_meta("_is_enabled") and obj.get_meta("_is_enabled") == false:
		push_warning("%s is not poolable object")
		return
		
	obj.set_meta("is_enabled", false)
	obj.global_position = Vector2.INF
	# await obj.get_tree().process_frame
	
	obj.get_parent().remove_child(obj)
	
	obj.visible = false
	obj.set_process(false)
	obj.set_physics_process(false)
	
	pool[obj.get_meta("_scene_path")].append(obj)


# TODO: Change Dictionary to Resource
static func spawn_object(scene: PackedScene, data: Dictionary = {}, parent: Node = GlobalContainer.entity_manager) -> Node:
	var obj: Node
	if pool.get_or_add(scene.resource_path, []).is_empty():
		obj = scene.instantiate()
	else :
		obj = pool.get_or_add(scene.resource_path, []).pop_front()
	
	obj.visible = true
	obj.set_process(true)
	obj.set_physics_process(true)
	obj.set_meta("_scene_path", scene.resource_path)
	
	if obj.has_method("init"):
		obj.init(data)
	parent.add_child(obj)
	obj.set_meta("is_enabled", true)
	
	return obj
