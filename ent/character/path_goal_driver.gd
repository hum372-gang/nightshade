extends CharacterDriver
class_name GoalDriver

@export var goal = Vector2.INF
@export var enabled = false

func absolute() -> Vector2:
	var a = character().agent
	if a.target_position == goal and a.is_navigation_finished():
		enabled = false
	return goal if enabled else Vector2.INF

func priority() -> float:
	return 1 if enabled else 0
