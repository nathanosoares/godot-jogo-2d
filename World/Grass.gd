extends Node2D

func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var instance = GrassEffect.instance()
	
	instance.global_position = global_position
	
	var world = get_tree().current_scene
	world.add_child(instance)

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
