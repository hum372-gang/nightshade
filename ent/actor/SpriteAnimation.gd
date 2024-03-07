extends Resource
class_name SpriteAnimation

@export var name = ""
@export var row = 0
@export var frame_count = 1
@export var looping = true
@export var timings: Array[float] = [0.1]
@export var reset_timer = true

func _init(_name, _row, _frame_count, _looping, _timings: Array[float], _reset_timer):
	name = _name
	row = _row
	frame_count = _frame_count
	looping = _looping
	timings = _timings
	reset_timer = _reset_timer

func get_frame(time: float) -> Vector2i:
	for frame in range(len(timings)):
		time -= timings[frame]
		if time <= 0:
			return Vector2(frame, row)
	return Vector2i(-1,-1)
