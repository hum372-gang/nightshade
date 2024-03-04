extends ActorDriver
class_name GoalDriver

@export var goal = Vector2.INF
@export var enabled = false
@export var active_priority = 1.0

func bypasses_control_setting():
	return true

func absolute() -> Vector2:
	var a = actor().agent
	if a.target_position == goal and a.is_navigation_finished():
		enabled = false
	return goal if enabled else Vector2.INF

func priority() -> float:
	return active_priority if enabled else 0.0
