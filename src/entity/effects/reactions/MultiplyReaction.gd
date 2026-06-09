extends Reaction
class_name MultiplyReaction

@export var multiply_fector = 1.0

# return = modifired damage
func apply_effect(attacker:Node2D, target: Node2D, base_damage: float) -> float:
	return base_damage * multiply_fector
