extends Area2D

export(bool) var show_hit = true
export(NodePath) onready var victim_path

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var victim = get_node(victim_path)

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = HitEffect.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
