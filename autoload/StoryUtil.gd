extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Inkleton.directive.connect(directive)
	pass # Replace with function body.

func directive(type: String, body: String, tags: PackedStringArray):
	match type.to_lower():
		"wait":
			var amt = float(body)
			Inkleton.block()
			await get_tree().create_timer(amt).timeout
			Inkleton.unblock()
