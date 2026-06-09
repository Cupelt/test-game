extends Reaction
class_name MultiplyReaction

@export var multiply_fector = 1.0

# return = modifired damage
func apply_effect(data: AttackInfo) -> float:
	return data.damage * multiply_fector
