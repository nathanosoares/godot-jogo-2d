extends Area2D

export var flipped = false setget setFlip

onready var sprite = $Sprite

func _ready():
	sprite.flip_h = flipped
	
func setFlip(new_value):
	flipped = new_value
	$Sprite.flip_h = flipped
