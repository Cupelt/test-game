extends Node2D

# Called when the node enters the scene tree for the first time.
@export var collision: CollisionShape2D
@export var stats: EntityStats
@onready var area = $Area2D

func _ready() -> void:
	$Area2D/CollisionShape2D.shape = collision.shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for body in area.get_overlapping_bodies():
		if body is Player:
			body.stats.hp -= stats.get_stat(EntityStats.StatType.ATTACK) * delta
	pass
