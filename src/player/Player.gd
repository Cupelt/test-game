extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var SPEED = 70;
@export var ACCEL = 2500;

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
	var beforeAnim = String(animated_sprite_2d.animation).split("_")
	 
	if (direction.is_zero_approx()):
		beforeAnim[0] = "Idle"
		# animated_sprite_2d.speed_scale = 1
	else:
		beforeAnim[0] = "Walk"
	
	if (direction.x != 0):
		beforeAnim[1] = "Left"
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
	
	if (direction.y < 0):
		beforeAnim[1] = "Up"
	elif (direction.y > 0):
		beforeAnim[1] = "Down"
	
	animated_sprite_2d.play("_".join(beforeAnim))
	#endregion

func set_player_speed(speed: float):
	SPEED = speed
