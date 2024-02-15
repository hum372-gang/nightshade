extends CharacterDriver
class_name FollowPathDriver

@export var priority_when_active = 0.5;
@export var satisfy_distance = 64.0;
var path: Path2D = null
var index = 0

func follow(it: Path2D):
	path = it
	index = 0

func control():
	if !path:
		return Vector2.ZERO
	if index >= path.curve.point_count:
		path = null
	if !path:
		return Vector2.ZERO
	var next_point = path.global_position + path.curve.get_point_position(index)
	var rel = next_point - get_parent().global_position
	return rel

func priority():
	return priority_when_active if path != null else -99999.0

func _process(delta):
	tick += delta
	if tick > 2.0:
		tick = 0
	if control().length() < satisfy_distance:
		index += 1
	

var tick = 0

func jump():
	if !path:
		return false
	var c = control()
	return (c.y / abs(c.x)) < -0.8 && tick < 1.9 && c.length() > 32
