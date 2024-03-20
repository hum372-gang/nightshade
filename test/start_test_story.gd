extends Node

func _ready():
	Inkleton.start_with(preload("res://ink/game-draft.ink"))
