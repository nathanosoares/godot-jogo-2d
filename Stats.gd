extends Node

export(float) var max_health = 20
onready var health = max_health setget set_health

signal no_health
signal damage

func set_health(new_health):
	if new_health < health:
		emit_signal("damage")
	
	health = min(max(new_health, 0), max_health)
	
	if health <= 0:
		emit_signal("no_health")
