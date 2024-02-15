extends Node2D
class_name Character

var new_action = 0
var action = false
var absolute = Vector2.INF
var control = Vector2.ZERO
var last_driver: CharacterDriver

@export var speed = 250.0
@export var aspect = 0.75
@onready var agent: NavigationAgent2D = %NavigationAgent2D

signal changed_driver(old: CharacterDriver, new: CharacterDriver)

func _ready():
	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 1.0

func _physics_process(delta):
	# Update controls
	if blockers == 0:
		var driver = get_children().filter(func (c): return c is CharacterDriver)
		driver.sort_custom(func(a, b): return a.priority()>b.priority())
		if len(driver)>0:
			driver = driver[0]
			if driver != last_driver:
				changed_driver.emit(last_driver, driver)
				last_driver = driver
			var _action = driver.action()
			if _action and not action:
				new_action = true;
			else:
				new_action = false;
			action = _action;
			control = driver.control()
			control = control.normalized() if control.length() > 1 else control
			absolute = driver.absolute()
	else:
		control = Vector2.ZERO
		absolute = Vector2.INF
		action = false
		new_action = false
	# Move
	var next_pos = agent.get_next_path_position()
	var real_control = (next_pos - global_position)
	var input_len
	if absolute != Vector2.INF:
		agent.target_position = absolute
		input_len = 1
	else:
		agent.target_position = global_position + (control * 10)
		input_len = control.length() * clamp(0, control.normalized().dot(real_control.normalized()), 1)
	real_control = real_control.normalized() * min(real_control.length(), input_len * speed * delta)
	global_position += real_control * Vector2(1, aspect)

var blockers = 0

func block():
	blockers += 1

func unblock():
	blockers = max(0, blockers-1)

func move_to(pos: Vector2):
	for driver in get_children().filter(func(c): c is GoalDriver):
		driver.goal = pos
		driver.enabled = true
	await changed_driver
