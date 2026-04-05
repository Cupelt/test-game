@abstract extends Node2D
class_name ObjectPool

var _scene_path: String
static var pool: Dictionary[String, Array]

var is_enabled: bool = true
signal destroied()

@abstract func init(data: Dictionary) -> void

func destroy_object() -> void:
	if (is_enabled == false): 
		return
		
	is_enabled = false
	global_position = Vector2.INF
	await get_tree().process_frame
	
	get_parent().remove_child(self)
	destroied.emit()
	
	self.visible = false
	self.set_process(false)
	self.set_physics_process(false)
	#for connection in destroied.get_connections():
		#destroied.disconnect(connection["callable"])
	
	pool[_scene_path].append(self)


# TODO: Change Dictionary to Resource
static func spawn_object(scene: PackedScene, data: Dictionary = {}, parent: Node = GlobalContainer.entity_manager) -> ObjectPool:
	var obj: ObjectPool
	if pool.get_or_add(scene.resource_path, []).is_empty():
		obj = scene.instantiate()
	else :
		obj = pool.get_or_add(scene.resource_path, []).pop_front()
	
	obj.visible = true
	obj.set_process(true)
	obj.set_physics_process(true)
	obj._scene_path = scene.resource_path
	
	obj.init(data)
	parent.add_child(obj)
	obj.is_enabled = true
	
	return obj
