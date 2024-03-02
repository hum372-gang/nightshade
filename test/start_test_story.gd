extends Node

func _ready():
	Inkleton.story = preload("res://ink/game-draft.ink")
	Inkleton.unblock()
