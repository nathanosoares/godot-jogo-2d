extends Area2D

export(float) var damage = 1
export(float, 0, 10) var knockback = 1

signal hit

func _on_Hitbox_area_entered(area):
	emit_signal("hit", area)
