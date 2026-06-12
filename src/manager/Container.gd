extends Node

var player: Player = null;
var entity_manager: EntityManager = null;
var camera: CameraManager = null;

var _attack_type_paths: Array[String] = [
	"res://settings/effects/attack_types/element/Electric.tres",
	"res://settings/effects/attack_types/element/Ice.tres",
	"res://settings/effects/attack_types/element/Pyro.tres",
	"res://settings/effects/attack_types/element/Void.tres",
	"res://settings/effects/attack_types/element/Water.tres",
	"res://settings/effects/attack_types/weapon/Greatsword.tres",
	"res://settings/effects/attack_types/weapon/Projectile.tres",
]
var attack_type_map: Dictionary[StringName, AttackType]

func _ready() -> void:
	for path in _attack_type_paths:
		var t: AttackType = load(path)
		attack_type_map[t.id] = t
