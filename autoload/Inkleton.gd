extends Node

var story: InkStory
var blockers: int = 0
var current_choices = []

#signal text(line: String, tags: Array[String])
# This is an array of InkChoice but because of some C# interop weirdness I can't
# make it strongly typed...
signal choices(choices: Array)
signal directive(type: String, content: String, tags: Array[String])

func _ready():
	block()
	#story = preload("res://ink/game.ink")

func block():
	blockers += 1
	set_process(false)

func unblock():
	blockers = max(0, blockers-1)
	if blockers <= 0:
		set_process(true)

func _process(_delta):
	if blockers > 0:
		return
	current_choices = []
	while story.GetCanContinue():
		var this_line: String = story.Continue()
		var tags = story.GetCurrentTags()
		var directives = this_line.split(";;")
		print("T: ", tags)
		for directive in directives:
			directive = directive.lstrip(" \r\n").rstrip(" \n\r")
			var first_colon = directive.find(':')
			var type = directive.substr(0, first_colon)
			var body = directive.substr(first_colon+1).lstrip(" \r\n").rstrip(" \r\n")
			print(type,": ",body)
			emit_signal("directive", type, body, tags)
		if blockers > 0:
			return
	var them = story.GetCurrentChoices()
	if !them:
		return
	for choice in them:
		print("> ", choice.Text)
	choices.emit(them)
	current_choices = them;
	block()
