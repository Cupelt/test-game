@abstract extends Node2D
class_name Entity

var components: Array[Component]
var _scene_name: String
static var entity_pool: Dictionary[String, Array]

@abstract func init(data: Dictionary) -> void

func _ready() -> void:
	components.assign(get_children().filter(func (node): node is Entity))

func destroy_entity() -> void:
	self.visible = false
	self.set_process(false)
	self.set_physics_process(false)
	
	get_parent().remove_child(self)
	
	entity_pool[_scene_name].append(self)

# TODO: Change Dictionary to Resource
static func spawn_entity(scene: PackedScene, parent: Node, data: Dictionary = {}) -> Entity:
	var entity: Entity
	if entity_pool.get_or_add(scene.resource_name, []).is_empty():
		entity = scene.instantiate()
	else :
		entity = entity_pool.get_or_add(scene.resource_name, []).pop_front()
	
	entity.visible = true
	entity.set_process(true)
	entity.set_physics_process(true)
	entity._scene_name = scene.resource_name
	
	entity.init(data)
	parent.add_child(entity)
	
	return entity
	
	
	
