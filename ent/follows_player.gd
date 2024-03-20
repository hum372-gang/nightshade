extends Node2D
class_name FollowsPlayer

func _ready():
	set_process(false)
	Actors.actor_entered.connect(func(a): if a == "P": set_process(true))

var player: Actor

func _process(delta):
	if !player:
		player = Actors.get_actor("P")
	if !player:
		set_process(false)
		return
	if !player.is_inside_tree():
		player = null
		set_process(false)
		return
	global_position = player.global_position
	pass
