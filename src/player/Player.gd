extends CharacterBody2D
class_name Player

@onready var animation_tree = $Sprite2D/AnimationTree
@export var SPEED = 70;
@export var ACCEL = 2500;

var map_pos: Vector2i = Vector2i.MAX

# Called when the node enters the scene tree for the first time. 2.15
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down") \
		.normalized()
	
	#region Player Movement
	velocity = velocity.move_toward(direction * SPEED, delta * ACCEL)
	# velocity = direction * SPEED
	#endregion
	
	#region Player Animation
	 
	animation_tree["parameters/is_walk/blend_amount"] = float(!direction.is_zero_approx())
	if (direction.x != 0):
		animation_tree["parameters/is_flip/blend_amount"] = float(direction.x < 0)
	#endregion

func set_player_speed(speed: float):
	SPEED = speed
