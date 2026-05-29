@abstract extends Resource
class_name Item

enum Quality {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHIC
}
	

@export var name: String
@export_multiline var description: String
@export var icon: Texture2D

func init():
	pass

func update(delta: float):
	pass
