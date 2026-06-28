extends Node

signal on_change_room(from: Vector2i, to: Vector2i, insatnce: RoomData)
signal on_stats_changed(body: Node2D, type: EntityStats, old_value: float, new_value: float)
signal on_attacked(data: AttackResult)
