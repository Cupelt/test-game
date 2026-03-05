extends CharacterBody2D
class_name Player

@onready var animation_tree = $Sprite2D/AnimationTree
@onready var stats: EntityStats = $StatsContainer

var map_pos: Vector2i = Vector2i.MAX

# Called when the node enters the scene tree for the first time. 2.15
func _ready() -> void:
	GlobalContainer.player = self
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down") \
		.normalized()
	
	#region Player Movement
	velocity = velocity.move_toward(direction * stats.speed, delta * stats.accel)
	# velocity = direction * SPEED
	#endregion
	
	#region Player Animation
	 
	animation_tree["parameters/is_walk/blend_amount"] = float(!direction.is_zero_approx())
	if (direction.x != 0):
		animation_tree["parameters/is_flip/blend_amount"] = float(direction.x < 0)
	#endregion
