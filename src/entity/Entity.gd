@abstract extends Node2D
class_name Entity

@export var stats: EntityStats
var components: Array[Component]
var _scene_path: String
static var entity_pool: Dictionary[String, Array]

var is_enabled: bool = true
signal destroied()

@abstract func init(data: Dictionary) -> void

func _ready() -> void:
	components.assign(get_children().filter(func (node): node is Entity))

func destroy_entity() -> void:
	if (is_enabled == false): 
		return
		
	is_enabled = false
	self.visible = false
	self.set_process(false)
	self.set_physics_process(false)
	
	get_parent().remove_child(self)
	destroied.emit()
	for connection in destroied.get_connections():
		destroied.disconnect(connection["callable"])
	
	entity_pool[_scene_path].append(self)

# TODO: Change Dictionary to Resource
static func spawn_entity(scene: PackedScene, data: Dictionary = {}, parent: Node = GlobalContainer.entity_manager) -> Entity:
	var entity: Entity
	if entity_pool.get_or_add(scene.resource_path, []).is_empty():
		entity = scene.instantiate()
	else :
		entity = entity_pool.get_or_add(scene.resource_path, []).pop_front()
	
	entity.visible = true
	entity.set_process(true)
	entity.set_physics_process(true)
	entity._scene_path = scene.resource_path
	
	entity.init(data)
	parent.add_child(entity)
	entity.is_enabled = true
	
	return entity
	
	
	
