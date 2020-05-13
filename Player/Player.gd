extends KinematicBody2D

const ACCELERATION = 40
const MAX_SPEED = 150
const FRICTION = 25

var velocity = Vector2.ZERO

# Player
onready var animationPlayer = $AnimationPlayer
onready var animationPlayerTree = $AnimationTree
onready var animationPlayerState = animationPlayerTree.get("parameters/playback")

# Weapon
onready var animationHitTree = get_node("Weapon/Pivot/AnimationTree")
onready var animationHitState = animationHitTree.get("parameters/playback")

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
		
	get_node("Weapon").rotation = -atan2(diff.x, diff.y)

func _input(event):
	
	if event is InputEventMouseButton and event.pressed:
		var hitAnimation = get_node("Weapon/Pivot/AnimationHit")
		
		if !hitAnimation.is_playing():
			var k = "parameters/Hit/blend_position"
			animationHitTree.set(k, -animationHitTree.get(k))
			animationHitState.start("Hit")
