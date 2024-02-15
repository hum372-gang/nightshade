extends CharacterDriver
class_name HumanCharacterDriver

func priority():
	return 1.0 if control().length() > 0 else 0.0

func jump():
	return Input.is_action_pressed("ui_accept")

func control():
	return Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down"))
