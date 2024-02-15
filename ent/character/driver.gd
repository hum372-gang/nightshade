class_name CharacterDriver
extends Node

func priority() -> float:
	return 0.0

func action() -> bool:
	return false

func control() -> Vector2:
	return Vector2.ZERO

func absolute() -> Vector2:
	return Vector2.INF

func character() -> Node:
	var c = get_parent()
	while not c is Character:
		c = c.get_parent()
	return c

func selected():
	pass

func deselected():
	pass
