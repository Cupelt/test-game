extends Node

signal on_change_room(from: Vector2i, to: Vector2i, insatnce: RoomData)
signal on_hp_changed(body: Node2D, before: float, after: float)
