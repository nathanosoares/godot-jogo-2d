extends Node2D

onready var collisionBox = $Pivot/PivotBase/Weapon/Hitbox/CollisionBox

func _on_AnimationHit_animation_started(_anim_name):
	collisionBox.disabled = false


func _on_AnimationHit_animation_finished(_anim_name):
	collisionBox.disabled = true
