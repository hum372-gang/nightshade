extends Node

class Message:
	var type: String
	var body: String
	var tags: PackedStringArray

var message_queue: Array[Message]

@onready var spoken_box = preload("res://gui/dialogue/spoken/spoken.tscn").instantiate()

func applicable(directive):
	match [directive.verb, directive.body]:
		[["Thought"], _]: return true
		[["Thought", var a], _] when Actors.get_actor(a) != null: return true
		[["Written"], _]: return true
		[[var a], _] when Actors.get_actor(a) != null or "remote" in directive.tags: return true
		_: return false

# Called when the node enters the scene tree for the first time.
func _ready():
	Inkleton.subscribe(applicable, directive, self)
	Inkleton.choices.connect(choices)
	add_child(spoken_box)
	spoken_box.get_node("%DialoguePanel").modulate = Color.TRANSPARENT
	spoken_box.get_node("%DialogueButtonPanel").hide()
	set_process(false)

func directive(directive):
	var body = " ".join(directive.body);
	match directive.verb:
		["Thought"]: thought(Actors.get_actor("P"), body, "async" in directive.tags)
		["Thought", var a]: thought(Actors.get_actor(a), body, "async" in directive.tags)
		["Written"]:
			printerr("TODO written messages")
			spoken(Actors.get_actor("P"), body, directive.tags)
		[var a]:
			spoken(Actors.get_actor(a), body, directive.tags)
		_: return
	remove_buttons()

func maybe_hide():
	var choices: Array = dialogue_choices();
	var dialogue_choices_exist = !choices.is_empty()
	if dialogue_choices_exist:
		return
	if Inkleton.queue.is_empty():
		spoken_box.change_target(null)
		return
	for directive in Inkleton.queue:
		match directive.verb:
			["Written"]: return
			[var a] when Actors.get_actor(a) != null or "remote" in directive.tags: return
			_: pass
	spoken_box.change_target(null)

func dialogue_choices():
	return Inkleton.get_choices()\
		.filter(func(c): return c.Text.begins_with("Dialogue: "))

@onready var button_panel = spoken_box.get_node("%DialogueButtonPanel")
@onready var button_parent = spoken_box.get_node("%DialogueButtonParent")

func remove_buttons():
	for child in button_parent.get_children():
		child.disabled = true
	button_panel.visible = false

func choices():
	var choices: Array = dialogue_choices();
	if choices.is_empty():
		return
	for child in button_parent.get_children():
		child.queue_free()
	for index in range(len(choices)):
		var choice = choices[index]
		var button = Button.new()
		button.text = choice.Text.trim_prefix("Dialogue: ")
		button.pressed.connect(func():
			button.release_focus()
			remove_buttons()
			Inkleton.choose_choice(index)
			maybe_hide())
		button_parent.add_child(button)
		if index == 0:
			button.grab_focus()
	button_panel.visible = true

func thought(actor: Actor, body: String, async: bool):
	var thought = preload("res://gui/dialogue/thought/thought.tscn").instantiate()
	var unblock = Inkleton.block(thought)
	if async:
		unblock.call()
	thought.text = body
	thought.target = actor
	add_child(thought)
	thought.run()

func spoken(actor: Actor, body: String, tags: Array[String]):
	#var unblock = Inkleton.block(spoken_box)
	await spoken_box.handle_message(actor, body, tags)
	maybe_hide()
	#unblock.call()

#func got_directive(type: String, body: String, tags: PackedStringArray):
	#if (Actors.get_actor(type) == null) \
		#and (not type.begins_with("Thought")) \
		#and (not type == "Written"):
		#return
	#Inkleton.block()
	#var msg = Message.new()
	#msg.type = type
	#msg.body = body
	#msg.tags = tags
	#message_queue.push_back(msg)
	## We don't want to start handling messages immediately in case the Inkleton
	## is going to send us more, so just wake up the node and do it when we get
	## scheduled next
	#set_process(true)
	#since_last_message = 0
#
#var since_last_message = 0
#
#func _process(_delta):
	## Don't schedule us while we're waiting on a message, to prevent spawning
	## infinite messages
	#set_process(false)
	#for message in message_queue:
		#match Array(message.type.split(" ")):
			#["Written"]:
				## I don't have a separate message box type for written messages
				## yet.
				#print("TODO")
				#await spoken.handle_message("P", "(WRITTEN) "+message.body, message.tags)
			#["Thought", var target]:
				## If it's async, don't bother waiting for it to finish.
				## This has to be a branch, since Godot doesn't let us store
				## awaitables in variables yet.
				#if "async" in message.tags:
					#thought(target, message.body, message.tags)
				#else:
					## Shut off spoken messages if we're currently showing one.
					#await spoken.change_target(null)
					#await thought(target, message.body, message.tags)
			#["Thought"]:
				## Separate branch for implicit player thoughts.
				## This probably doesn't need to exist, but I don't know enough
				## about Godot's match syntax to DRY it up.
				#if "async" in message.tags:
					#thought("P", message.body, message.tags)
				#else:
					#await spoken.change_target(null)
					#await thought("P", message.body, message.tags)
			#[var character]:
				#await spoken.handle_message(character, message.body, message.tags)
	## We block the inkleton whenever we receive a message, so unblock it again.
	#if not message_queue.is_empty():
		#Inkleton.unblock()
	## Keep looking for messages, so we don't cancel a messagebox while another
	## one is incoming.
	#message_queue.clear()
	## Ok, we can be safely scheduled again
	#set_process(true)
	#since_last_message += 1
	#if since_last_message > 3:
		#set_process(false)
		#await spoken.change_target(null)
#
#func thought(target, text, tags):
	## Set up the 
	#var thought = preload("res://gui/dialogue/thought/thought.tscn").instantiate()
	#thought.text = text
	#thought.target = Actors.get_actor(target)
	#thought.tags = tags
	#add_child(thought)
	##await get_tree().process_frame
	#thought.run()
	#await thought.finished
	#thought.queue_free()
