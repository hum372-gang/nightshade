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
	if (Actors.get_actor(type) == null) and not type in ["Thought", "Written"]:
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
		match message.type:
			#"Thought":
				#print("TODO")
				#spoken.change_target(null)
			#"Written":
				#print("TODO")
				#spoken.change_target(null)
			_:
				await spoken.handle_message(message.type, message.body, message.tags)
				Inkleton.unblock()
	set_process(true)
	message_queue.clear()
	since_last_message += 1
	if since_last_message > 3:
		set_process(false)
		spoken.change_target(null)
