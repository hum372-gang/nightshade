extends Control

func _ready():
	Inkleton.text.connect(self.text)
	Inkleton.choices.connect(self.choices)
	Inkleton.unblock()

func text(line: String, tags: Array):
	if line.begins_with(">>>"):
		return
	if "parallel" not in tags:
		Inkleton.block()
	var label = Label.new()
	label.text = line
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	await typewriter(0.01, label)
	if "parallel" not in tags:
		Inkleton.unblock()

func choices(them: Array):
	for index in range(len(them)):
		var choice = them[index]
		var button: Button = Button.new()
		button.text = choice.Text
		button.pressed.connect(choose.bind(index, choice.Text))
		await fade_in(0.25, button)

func choose(index: int, _line: String):
	for child in get_children():
		if child is Button:
			child.queue_free()
	Inkleton.story.ChooseChoiceIndex(index)
	Inkleton.unblock()

func typewriter(time: float, l: Label):
	l.visible_characters = 0
	add_child(l)
	await get_tree().process_frame
	get_parent().ensure_control_visible(l)
	await create_tween().bind_node(l).tween_method(func(v): l.visible_characters = v, 0, len(l.text), time * len(l.text)).finished

func fade_in(time: float, c: Control):
	c.modulate.a = 0
	add_child(c)
	await get_tree().process_frame
	get_parent().ensure_control_visible(c)
	await create_tween().bind_node(c).tween_method(func(v): c.modulate.a = v, 0.0, 1.0, time).finished
