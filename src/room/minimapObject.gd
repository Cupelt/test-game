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
@export var icon: TextureRect

func update_room(state: MinimapState):
	self.state = state
	
	if !(state == MinimapState.BLINDED):
		show()
	
	match state:
		MinimapState.NO_VISIT:
			blined_obejct.show()
			visited_object.hide()
		MinimapState.VISITED:
			blined_obejct.hide()
			visited_object.show()

func set_icon_visible(visible: bool):
	icon.visible = visible
