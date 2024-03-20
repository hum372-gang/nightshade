extends Node2D
class_name InteractWatcher

var time_since_blocked = 0

func _process(delta):
	var handles: Array[InteractHandle] = []
	if handles.is_empty():
		return
	# Find all interact handles
	handles.assign(get_tree()\
		.get_nodes_in_group("InteractHandle")\
		.filter(func(n): return n is InteractHandle))
	for handle in handles:
		handle.hide()
	if (get_parent().blockers > 0)\
		or (!Inkleton.blockers.is_empty()):
		time_since_blocked = 0.25
		return
	time_since_blocked = max(0, time_since_blocked-delta)
	if time_since_blocked > 0:
		return
	var active_handles: Array[InteractHandle] = handles\
		.filter(func(h: InteractHandle): return h.player_is_in_region)\
		.filter(func(h: InteractHandle):
			var choice_name = h.choice_type + ": " + h.choice_name
			for choice in Inkleton.get_choices():
				if choice.Text == choice_name:
					return true
			return false)
	for handle in active_handles:
		handle.show()
		handle.modulate = Color(1, 1, 1, 0.5)
	handles.sort_custom(func(a, b):
		return (a.global_position.distance_to(self.global_position) \
		< b.global_position.distance_to(self.global_position)))
	var handle = handles[0]
	var choice_name = handle.choice_type + ": " + handle.choice_name
	handle.modulate = Color.WHITE
	var choices = Inkleton.get_choices()
	if Input.is_action_just_pressed("ui_accept"):
		for handle_ in active_handles:
			handle_.hide()
		for index in range(len(choices)):
			if choices[index].Text == choice_name:
				Inkleton.choose_choice(index)
				return
