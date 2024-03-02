extends Area2D
class_name InteractHandle

var player: Node2D
var player_is_in_region: bool = false
var choice_is_present: bool = false
var choice_index = 0

func _ready():
	body_entered.connect(fire.bind(true))
	body_exited.connect(fire.bind(false))
	Inkleton.directive.connect(directive)
	Inkleton.choices.connect(choices)

func directive(_type, _body, _tags):
	choice_is_present = false
	set_process(true)

@export var choice_type: String = "Interact"
@export var choice_name: String = "Default"

func choices(choices: Array):
	var target = choice_type + ": " + choice_name
	var matching = choices.filter(func(c): return c.Text == target)
	if matching.is_empty():
		choice_index = -1
		choice_is_present = false
		return
	choice_index = matching[0].Index
	choice_is_present = true
	set_process(true)

func _process(delta):
	if !player:
		player = Actors.get_actor("P")
	if !player:
		set_process(false)
		return
	if not (player_is_in_region and choice_is_present):
		set_process(false)
		hide()
		return
	show()
	# This is awful
	var handles = get_tree() \
		.get_nodes_in_group("InteractHandle") \
		.filter(func(n):
			return n is InteractHandle \
				and n.player_is_in_region \
				and n.choice_is_present)
	handles.sort_custom(func(a, b):
		return (a.global_position.distance_to(player.global_position) \
		< b.global_position.distance_to(player.global_position)))
	if handles[0] != self:
		%Label.hide()
		%Sprite2D.modulate = Color(1, 1, 1, 0.5)
		return
	%Label.show()
	%Sprite2D.modulate = Color.WHITE
	if player.blockers == 0 and Input.is_action_just_pressed("ui_accept"):
		Inkleton.story.ChooseChoiceIndex(choice_index)
		Inkleton.unblock()
		set_process(false)

func fire(body: PhysicsBody2D, entered: bool):
	var player: Character = body.get_parent();
	if !player.is_in_group("Player"):
		return
	player_is_in_region = entered
	if player_is_in_region:
		set_process(true)
