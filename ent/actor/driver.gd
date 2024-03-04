class_name ActorDriver
extends Node

func bypasses_control_setting() -> bool:
	return false

func priority() -> float:
	return 0.0

func action() -> bool:
	return false

func control() -> Vector2:
	return Vector2.ZERO

func absolute() -> Vector2:
	return Vector2.INF

func actor() -> Node:
	var c = get_parent()
	while not c is Actor:
		c = c.get_parent()
	return c

func selected():
	pass

func deselected():
	pass
