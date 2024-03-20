extends Area2D
class_name InteractHandle

var player_is_in_region: bool = false

func _ready():
	body_entered.connect(fire.bind(true))
	body_exited.connect(fire.bind(false))

@export var choice_type: String = "Interact"
@export var choice_name: String = "Default"

func fire(body: PhysicsBody2D, entered: bool):
	var player: Actor = body.get_parent();
	if !player.is_in_group("Player"):
		return
	player_is_in_region = entered
