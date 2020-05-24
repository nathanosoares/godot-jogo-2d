extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0 
var priority = 0

onready var camera = get_parent()
onready var shakeTween = $ShakeTween
onready var frequency = $Frequency
onready var duration = $Duration

func start(duration = 0.2, frequency = 15, aplitude = 16, priority = 0):
	if priority >= self.priority:
		self.duration.wait_time = duration
		self.frequency.wait_time = 1 / float(frequency)
		self.amplitude = aplitude
		self.priority = priority
		
		self.duration.start()
		self.frequency.start()
		
		_new_shake()

func _new_shake():
	var rand = Vector2(rand_range(-amplitude, amplitude), rand_range(-amplitude, amplitude))
	_animate(rand)

func _animate(vec: Vector2):
	shakeTween.interpolate_property(
		camera, 
		"offset", 
		camera.offset, 
		vec, 
		frequency.wait_time,
		TRANS,
		EASE
	)
	shakeTween.start()

func _reset():
	_animate(Vector2.ZERO)
	priority = 0

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset();
	frequency.stop()
