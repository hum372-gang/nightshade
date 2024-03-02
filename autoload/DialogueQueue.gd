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
	set_process(true)
	since_last_message = 0

var since_last_message = 0

func _process(_delta):
	set_process(false)
	for message in message_queue:
		match Array(message.type.split(" ")):
			["Written"]:
				print("TODO")
				await spoken.handle_message("P", "(WRITTEN) "+message.body, message.tags)
				Inkleton.unblock()
			["Thought", var target]:
				spoken.change_target(null)
				if "async" in message.tags:
					thought(target, message.body, message.tags)
				else:
					await thought(target, message.body, message.tags)
				Inkleton.unblock()
			["Thought"]:
				spoken.change_target(null)
				if "async" in message.tags:
					thought("P", message.body, message.tags)
				else:
					await thought("P", message.body, message.tags)
				Inkleton.unblock()
			[var character]:
				await spoken.handle_message(character, message.body, message.tags)
				Inkleton.unblock()
			_:
				Inkleton.unblock()
	set_process(true)
	message_queue.clear()
	since_last_message += 1
	if since_last_message > 3:
		set_process(false)
		spoken.change_target(null)

func thought(target, text, tags):
	var thought = preload("res://gui/dialogue/thought/thought.tscn").instantiate()
	thought.text = text
	thought.target = Actors.get_actor(target)
	thought.tags = tags
	add_child(thought)
	await get_tree().process_frame
	await thought.run()
	thought.queue_free()
