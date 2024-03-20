extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Inkleton.choices.connect(choices)
	pass # Replace with function body.

func choices():
	for child in get_children():
		child.queue_free()
	var choices = Inkleton.get_choices()
	for index in range(len(choices)):
		var choice = choices[index]
		var button = Button.new()
		button.pressed.connect(func(): Inkleton.choose_choice(index))
		button.text = choice.Text
		add_child(button)
