extends Node

var actor_positions: Dictionary = {}
var actors_present: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Inkleton.directive.connect(directive)
	SceneLoader.change_scene.connect(change_scene)

func change_scene(_from, _to):
	actors_present = []

func directive(type: String, body: String):
	match type.to_lower():
		"appears":
			appears(body)
		"enters":
			enters(body)
		"exit":
			exit(body)
		"moves":
			moves(body)
		"act":
			act(body)

func mk_actor(name: String):
	var actor: PackedScene = load("res://actor/"+name+".tscn")
	return actor.instantiate()

func get_actor(name: String):
	var actors = get_tree().get_nodes_in_group("Actor")
	for actor in actors:
		if actor.id == name:
			return actor
	return null

func update_last_position(of_actor: String):
	actor_positions[of_actor] = SceneLoader.current_stage

func get_landmark(name: String) -> Node2D:
	var landmarks = get_tree().get_nodes_in_group("Landmark")
	for landmark in landmarks:
		if landmark.id == name:
			return landmark
	return null

func appears(body: String):
	var parts = body.split(" ", false, 2)
	var actor_name = parts[0]
	var landmark_name = parts[1]
	var landmark = get_landmark(landmark_name)
	if actor_name in actors_present:
		get_actor(actor_name).global_position = landmark.global_position
	update_last_position(actor_name)
	var actor = mk_actor(actor_name)
	actor.global_position = landmark.global_position
	actors_present.push_back(actor_name)
	get_tree().current_scene.add_child(actor)

func enters(body: String):
	var parts = body.split(" ", false, 2)
	var actor_name = parts[0]
	if actor_name in actors_present:
		return
	var fallback = parts[1] if len(parts) > 1 else "Landmark"
	var door: Door
	var last_room = actor_positions.get(actor_name, false)
	if last_room:
		for _door in get_tree().get_nodes_in_group("Door"):
			if _door.room == last_room:
				door = _door
				break;
	var spawn_point: String = door.get_node("%Exit").id if door else fallback
	var goal: String = door.get_node("%Entrance").id if door else fallback
	Inkleton.block()
	appears(actor_name+" "+spawn_point)
	if goal:
		await moves(actor_name+" "+goal)
	Inkleton.unblock()
	pass

func exit(exit_name: String):
	var door: Door
	for _door in get_tree().get_nodes_in_group("Door"):
		if _door.choice_name == exit_name:
			door = _door
	if !door:
		return
	var exit: Landmark = door.get_node("%Exit")
	Inkleton.block()
	await moves("P "+exit.id)
	Inkleton.unblock()

func moves(body: String):
	var parts = body.split(" ", false, 2)
	var actor_name = parts[0]
	var goal_id = parts[1]
	var actor: Character = get_actor(actor_name)
	var goal: Landmark = get_landmark(goal_id)
	Inkleton.block()
	await actor.move_to(goal.global_position)
	Inkleton.unblock()

func act(body: String):
	pass