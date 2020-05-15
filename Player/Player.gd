extends KinematicBody2D

const ACCELERATION = 40
const MAX_SPEED = 150
const FRICTION = 25

var velocity = Vector2.ZERO

var hit = false

# Player
onready var animationPlayerTree = $AnimationTree
onready var animationPlayerState = animationPlayerTree.get("parameters/playback")

# Weapon
onready var hitAnimation = get_node("Sword/Pivot/AnimationHit")

func _physics_process(_delta):
	var input_strength = Vector2.ZERO;
	
	input_strength.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_strength.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_strength = input_strength.normalized()

	if input_strength != Vector2.ZERO:
		velocity = velocity.move_toward(input_strength * MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	velocity = move_and_slide(velocity)
	
	var diff = get_viewport().get_mouse_position() - position
	
	animationPlayerTree.set("parameters/Idle/blend_position", diff)
	animationPlayerTree.set("parameters/Run/blend_position", diff)
	
	if input_strength == Vector2.ZERO:
		animationPlayerState.travel("Idle")
	else:
		animationPlayerState.travel("Run")

	get_node("Sword").rotation = -atan2(diff.x, diff.y)

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		hit = !hit
		if hit:
			hitAnimation.play("HitAnimation")
		else:
			hitAnimation.play_backwards("HitAnimation")
