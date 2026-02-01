extends Control
class_name MinimapObject

enum MinimapState {
	BLINDED,
	NO_VISIT,
	VISITED
}

var state: MinimapState = MinimapState.BLINDED
@export var blined_obejct: Control
@export var visited_object: Control

func update_room(state: MinimapState):
	self.state = state
	
	match state:
		MinimapState.BLINDED:
			blined_obejct.hide()
			visited_object.hide()
		MinimapState.NO_VISIT:
			blined_obejct.show()
			visited_object.hide()
		MinimapState.VISITED:
			blined_obejct.hide()
			visited_object.show()
	
