extends Area2D
class_name Trigger

@export var on_exit = false
@export var block_player_until_available = true
@export var choice_type = "Trigger"
@export var choice_name = "Default"

var enabled = false;

func _ready():
	# Wait a little before we start caring about player movements, to prevent
	# loading zone oscillation
	Actors.actor_entered.connect(func(a): if a == "P": self.activate.call_deferred(), CONNECT_ONE_SHOT)

func activate():
	await get_tree().create_timer(0.5).timeout
	body_entered.connect(fire.bind(true))
	body_exited.connect(fire.bind(false))

func fire(body: Node2D, entered: bool):
	if !((entered && !on_exit) || (!entered && on_exit)):
		return;
	if !(body.get_parent() is Actor):
		return;
	var player: Actor = body.get_parent();
	if !player.is_in_group("Player"):
		return
	if player.blockers > 0:
		return
	if (not Inkleton.queue.is_empty()) && block_player_until_available:
		player.block()
		while not (Inkleton.queue.is_empty() and Inkleton.blockers.is_empty()):
			await get_tree().process_frame
		player.unblock()
	var choices = Inkleton.get_choices()
	var target = choice_type + ": " + choice_name
	for index in range(len(choices)):
		if choices[index].Text == target:
			Inkleton.choose_choice(index)
			return
	print("Warn: Tried to pick option ", target, " from trigger, but it isn't available.")
