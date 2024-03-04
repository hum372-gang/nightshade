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
	await get_tree().create_timer(0.25).timeout
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
	if Inkleton.current_choices == [] && block_player_until_available:
		player.block()
		await Inkleton.choices
		player.unblock()
	var choices = Inkleton.current_choices
	var target = choice_type + ": " + choice_name
	for index in range(len(choices)):
		if choices[index].Text == target:
			Inkleton.story.ChooseChoiceIndex(index)
			Inkleton.unblock()
			return
	print("Warn: Tried to pick option ", target, " from trigger, but it isn't available.")
