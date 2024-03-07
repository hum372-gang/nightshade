extends Sprite2D

@export var default_prefix = ""
@export var animations: Array[SpriteAnimation] = []
@export var include_defaults = true

@onready var prefix = default_prefix
var playing_special: SpriteAnimation = null
var playback_timer = 0.0

func _ready():
	if include_defaults:
		var timings: Array[float] = [0.25, 0.25, 0.25, 0.25]
		var defaults = [
			SpriteAnimation.new("down", 0, 4, true, timings, false),
			SpriteAnimation.new("up", 1, 4, true, timings, false),
			SpriteAnimation.new("right", 2, 4, true, timings, false),
			SpriteAnimation.new("left", 3, 4, true, timings, false)
		]
		animations.append_array(defaults)
		last_animation = defaults[0]
	else:
		last_animation = animations[0]

func get_animation(name: String) -> SpriteAnimation:
	for animation in animations:
		if animation.name == (prefix + name):
			return animation
	for animation in animations:
		if animation.name == (name):
			return animation
	return null

func _process(delta):
	playback_timer += delta
	var frame = Vector2i(-1,-1)
	if playing_special == null:
		frame = do_walk_animations()
	else:
		frame = do_special_animation()
	frame_coords = frame

var last_animation: SpriteAnimation = null

func do_walk_animations() -> Vector2i:
	var walk_vector: Vector2 = get_parent().control
	if walk_vector.length() == 0:
		return last_animation.get_frame(0)
	walk_vector.y *= 0.5
	var angle = walk_vector.angle()
	angle /= PI/2
	angle = int(round(angle))
	var name = {
		0: "right",
		-1: "up",
		2: "left",
		-2: "left",
		1: "down"
	}.get(angle, "down")
	print(angle, name)
	var animation = get_animation(name)
	if last_animation != animation:
		if animation.reset_timer:
			playback_timer = 0
		last_animation = animation
	var frame = animation.get_frame(playback_timer)
	if frame == Vector2i(-1,-1):
		playback_timer = 0
	return animation.get_frame(playback_timer)

func do_special_animation() -> Vector2i:
	return Vector2i(-1,-1)
