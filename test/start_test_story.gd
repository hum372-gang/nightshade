extends Node

func _ready():
	Inkleton.start_with(preload("res://ink/test_story.ink"))
