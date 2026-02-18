extends Node2D
class_name RoomRegistry

var source_id: int = -1;
var _room_id: Dictionary[PackedScene, int]

func initailize_tileset(tilemap: TileMapLayer, rooms: Array[AbstractRoom]):
	var collection: TileSetScenesCollectionSource = TileSetScenesCollectionSource.new()
	for gen in rooms:
		for scene in gen.presets:
			# 생성된 TileSetScenesCollectionSource 의 아이디에 대응 하는 RoomData를 저장
			_room_id[scene] = collection.create_scene_tile(scene)
	
	source_id = tilemap.tile_set.add_source(collection)


func get_room_id(scene: PackedScene) -> int:
	return _room_id[scene]

func has_room_id(scene: PackedScene) -> bool:
	return _room_id.has(scene)
