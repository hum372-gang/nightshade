extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Inkleton.subscribe(applicable, directive, self)
	pass # Replace with function body.

func applicable(directive):
	match [directive.verb, directive.body]:
		[["Wait"], [var f]] when float(f) != null: return true
		_: return false

func directive(directive):
	match [directive.verb, directive.body]:
		[["Wait"], [var f]]:
			var amt = float(f)
			var unblock = Inkleton.block(self)
			await get_tree().create_timer(amt).timeout
			unblock.call()
		_: return false
