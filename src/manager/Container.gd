extends Node

var player: Player = null;
var entity_manager: EntityManager = null;
var camera: CameraManager = null;

var attack_types: Array[AttackType]
var attack_type_map: Dictionary[StringName, AttackType]

func _ready() -> void:
	for i in attack_types:
		attack_type_map[i.id] = i
