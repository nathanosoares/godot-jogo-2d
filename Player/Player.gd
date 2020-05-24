extends KinematicBody2D

export(int) var MAX_SPEED = 110

const ACCELERATION = 600
const FRICTION = 600

var velocity = Vector2.ZERO

var hit = false

var stats = PlayerStats

onready var camera = get_tree().get_root().get_node("World/Camera2D")

onready var animationPlayerTree = $AnimationTree
onready var animationPlayerState = animationPlayerTree.get("parameters/playback")

onready var hitAnimation = get_node("Sword/Pivot/AnimationHit")
onready var swordHitbox = $Sword/Pivot/PivotBase/Weapon/Hitbox

func _ready():
	stats.connect("no_health", self, "queue_free")

func _physics_process(delta):
	var input_strength = Vector2.ZERO;
	
	input_strength.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_strength.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_strength = input_strength.normalized()
	
	if input_strength != Vector2.ZERO:
		velocity = velocity.move_toward(input_strength * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	var diff = (camera.get_global_mouse_position() - position).normalized()
	
	swordHitbox.knockback_vector = diff
	
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


func _on_Hitbox_hit(area):
	if area != null && area.get_filename() == "res://Overlap/Hurtbox.tscn":
		if area.victim != null:
			get_tree().get_root().get_node("World/Camera2D/Effects/Shake").start(0.2, 15, 2, 1)
