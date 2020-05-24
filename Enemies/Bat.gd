extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export(int) var FRICTION = 10
export(int) var ACCELERATION = 500
export(int) var MAX_SPEED = 260

var velocity = Vector2.ZERO 
var knockback = Vector2.ZERO 
var state = CHASE

onready var animatedSprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone

enum {
	IDLE, WANDER, CHASE
}

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	seek_player()
	
	match state:
		IDLE:
			velocity = Vector2.ZERO
			#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			pass
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				animatedSprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity)


func seek_player():
	if playerDetectionZone.player != null:
		state = CHASE
	else:
		state = IDLE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	
	var diff = (get_viewport().get_mouse_position() - position).normalized()
	
	knockback = diff * 120

func _on_Stats_no_health():
	queue_free()
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)
