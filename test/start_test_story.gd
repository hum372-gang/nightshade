extends Node

func _ready():
	Inkleton.story = preload("res://ink/test_story.ink")
	Inkleton.unblock()
