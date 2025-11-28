extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 150;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down") \
		.normalized()
	
	#region Player Movement
	velocity = direction * SPEED
	#endregion
	
	#region Player Animation
	var beforeAnim = String(animated_sprite_2d.animation).split("_")
	 
	if (direction.is_zero_approx()):
		beforeAnim[0] = "Idle"
		animated_sprite_2d.speed_scale = 1
	else:
		beforeAnim[0] = "Walk"
		animated_sprite_2d.speed_scale = SPEED / 100.0
	
	if (direction.x < 0):
		beforeAnim[1] = "Left"
	elif (direction.x > 0):
		beforeAnim[1] = "Right"
	elif (direction.x == 0 and direction.y != 0):
		beforeAnim[1] = "0"
	
	if (direction.y < 0):
		beforeAnim[2] = "Up"
	elif (direction.y > 0 or 
		(direction.x != 0 and direction.y == 0)):
		beforeAnim[2] = "Down"
	
	animated_sprite_2d.play("_".join(beforeAnim))
	#endregion
