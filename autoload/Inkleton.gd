#extends Node
#
#var story: InkStory
#var blockers: int = 0
#var current_choices = []
#
##signal text(line: String, tags: Array[String])
## This is an array of InkChoice but because of some C# interop weirdness I can't
## make it strongly typed...
#signal choices(choices: Array)
#signal directive(type: String, content: String, tags: Array[String])
#
#func _ready():
	## Start blocked so that the game has a chance to start the story
	#block()
#
#func block():
	#blockers += 1
	#set_process(false)
#
#func unblock():
	#blockers = max(0, blockers-1)
	#if blockers <= 0:
		#set_process(true)
#
#func _process(_delta):
	#if blockers > 0:
		#set_process(false)
		#return
	#current_choices = []
	#while story.GetCanContinue():
		#var this_line: String = story.Continue()
		#var tags = story.GetCurrentTags()
		#var directives = this_line.split(";;")
		#print("T: ", tags)
		#for directive in directives:
			#directive = directive.lstrip(" \r\n").rstrip(" \n\r")
			#var first_colon = directive.find(':')
			#var type = directive.substr(0, first_colon)
			#var body = directive.substr(first_colon+1).lstrip(" \r\n").rstrip(" \r\n")
			#print(type,": ",body)
			#emit_signal("directive", type, body, tags)
		#if blockers > 0:
			#set_process(false)
			#return
	#block()
	#var them = story.GetCurrentChoices()
	#if !them:
		#return
	#for choice in them:
		#print("> ", choice.Text)
	#choices.emit(them)
	#current_choices = them;

extends Node

var story: InkStory

class Subscriber:
	var applicable: Callable
	var callback: Callable
	func _init():
		applicable = func(_x): return false
		callback = func(_x): pass

var subscribers: Array[Subscriber] = []

## Adds a subscriber to the Ink story. 
func subscribe(applicable: Callable, callback: Callable, node: Node = null) -> Callable:
	var sub = Subscriber.new()
	sub.applicable = applicable
	sub.callback = callback
	subscribers.push_back(sub)
	var remove = func():
		var index = subscribers.find(sub);
		if index >= 0:
			subscribers.remove_at(index)
	if node:
		node.tree_exiting.connect(remove)
	return remove

class Directive:
	var verb: Array[String]
	var body: Array[String]
	var tags: Array[String]
	var block_before: bool
	func _init():
		verb = ["N/A"]
		body = ["N/A"]
		block_before = false

var queue: Array[Directive] = []

func queue_directive(verb: Array[String], body: Array[String], block_before = true, immediate = false):
	var dir = Directive.new()
	dir.verb = verb
	dir.body = body
	dir.block_before = block_before
	if immediate:
		queue.push_front(dir)
	else:
		queue.push_back(dir)

var blockers: Array[Node] = []
signal unblocked

func block(node: Node) -> Callable:
	blockers.push_back(node)
	var remove = func():
		var index = blockers.find(node)
		if index >= 0:
			blockers.remove_at(index)
			if blockers.is_empty():
				unblocked.emit()
				if queue.is_empty():
					choices.emit()
				emit_queued()
	if node:
		node.tree_exiting.connect(remove)
	return remove

func start_with(story_: InkStory):
	story = story_
	tick()

signal choices

func get_choices():
	return story.GetCurrentChoices()

func tick():
	while story.GetCanContinue():
		var line = story.Continue().strip_edges(true, true)
		if line == "":
			continue
		var tags = story.GetCurrentTags()
		var group = Array(line.split(";;"))
		var directive_group = Array(group).map(func(directive_string: String):
			var sep: int = directive_string.find(":")
			var verb = Array(directive_string.substr(0, sep).split(" ", false)).map(func(s): return s.strip_edges(true, true))
			var body = Array(directive_string.substr(sep+1).split(" ", false)).map(func(s): return s.strip_edges(true, true))
			var dir = Directive.new()
			dir.verb.assign(verb)
			dir.body.assign(body)
			dir.tags.assign(tags)
			return dir
		)
		directive_group[0].block_before = true;
		for directive in directive_group:
			queue.push_back(directive)
	emit_queued()

func emit_queued():
	var dispatched_counter = 0
	while not queue.is_empty():
		if queue[0].block_before:
			await get_tree().process_frame
			if not blockers.is_empty():
				return
		var directive = queue.pop_front()
		if directive == null:
			continue
		var applicable = subscribers.filter(func(s: Subscriber): return s.applicable.call(directive))
		if len(applicable) != 1:
			printerr("WARN: ", str(len(applicable)), " subscribers want directive ", " ".join(directive.verb), ": ", " ".join(directive.body))
		for subscriber in applicable:
			subscriber.callback.call(directive)
		dispatched_counter += 1
	if dispatched_counter > 0 and blockers.is_empty():
		(func(): choices.emit()).call_deferred()

func choose_choice(index: int):
	if index >= len(story.GetCurrentChoices()):
		printerr("Tried to choose an out-of-bounds choice")
		return
	story.ChooseChoiceIndex(index)
	tick()
