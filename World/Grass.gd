extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var effect = GrassEffect.instance()
	effect.global_position = global_position
	get_parent().add_child(effect)

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
