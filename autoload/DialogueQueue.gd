extends Node

class Message:
	var type: String
	var body: String
	var tags: PackedStringArray

var message_queue: Array[Message]

@onready var spoken = preload("res://gui/dialogue/spoken/spoken.tscn").instantiate()

func _ready():
	Inkleton.directive.connect(got_directive)
	add_child(spoken)
	spoken.get_node("%Control").modulate = Color.TRANSPARENT
	set_process(false)

func got_directive(type: String, body: String, tags: PackedStringArray):
	if (Actors.get_actor(type) == null) \
		and (not type.begins_with("Thought")) \
		and (not type == "Written"):
		return
	Inkleton.block()
	var msg = Message.new()
	msg.type = type
	msg.body = body
	msg.tags = tags
	message_queue.push_back(msg)
	# We don't want to start handling messages immediately in case the Inkleton
	# is going to send us more, so just wake up the node and do it when we get
	# scheduled next
	set_process(true)
	since_last_message = 0

var since_last_message = 0

func _process(_delta):
	# Don't schedule us while we're waiting on a message, to prevent spawning
	# infinite messages
	set_process(false)
	for message in message_queue:
		match Array(message.type.split(" ")):
			["Written"]:
				# I don't have a separate message box type for written messages
				# yet.
				print("TODO")
				await spoken.handle_message("P", "(WRITTEN) "+message.body, message.tags)
			["Thought", var target]:
				# If it's async, don't bother waiting for it to finish.
				# This has to be a branch, since Godot doesn't let us store
				# awaitables in variables yet.
				if "async" in message.tags:
					thought(target, message.body, message.tags)
				else:
					# Shut off spoken messages if we're currently showing one.
					await spoken.change_target(null)
					await thought(target, message.body, message.tags)
			["Thought"]:
				# Separate branch for implicit player thoughts.
				# This probably doesn't need to exist, but I don't know enough
				# about Godot's match syntax to DRY it up.
				if "async" in message.tags:
					thought("P", message.body, message.tags)
				else:
					await spoken.change_target(null)
					await thought("P", message.body, message.tags)
			[var character]:
				await spoken.handle_message(character, message.body, message.tags)
	# We block the inkleton whenever we receive a message, so unblock it again.
	if not message_queue.is_empty():
		Inkleton.unblock()
	# Keep looking for messages, so we don't cancel a messagebox while another
	# one is incoming.
	message_queue.clear()
	# Ok, we can be safely scheduled again
	set_process(true)
	since_last_message += 1
	if since_last_message > 3:
		set_process(false)
		await spoken.change_target(null)

func thought(target, text, tags):
	# Set up the 
	var thought = preload("res://gui/dialogue/thought/thought.tscn").instantiate()
	thought.text = text
	thought.target = Actors.get_actor(target)
	thought.tags = tags
	add_child(thought)
	#await get_tree().process_frame
	thought.run()
	await thought.finished
	thought.queue_free()
