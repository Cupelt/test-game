extends Node2D

var target: Node2D
@export var stats: EntityStats

var nav_agent_node: NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nav_agent_node = $NavigationAgent2D
	target = GlobalContainer.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null:
		return
	
	nav_agent_node.target_position = target.global_position
	var next_position = nav_agent_node.get_next_path_position()
	
	if !next_position:
		return
	
	var direction = (next_position - global_position).normalized()
	$"..".velocity = $"..".velocity.move_toward(direction * stats.speed, delta * stats.accel)
	$"..".move_and_slide()
	
	pass
