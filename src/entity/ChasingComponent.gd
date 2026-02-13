extends Node2D

@export var target: Node2D
@export var SPEED = 70;
@export var ACCEL = 2500;

var nav_agent_node: NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nav_agent_node = $NavigationAgent2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null:
		return
	
	nav_agent_node.target_position = target.global_position
	var next_position = nav_agent_node.get_next_path_position()
	
	if !next_position:
		return
	
	var direction = (next_position - global_position).normalized()
	$"..".velocity = $"..".velocity.move_toward(direction * SPEED, delta * ACCEL)
	$"..".move_and_slide()
	
	pass
