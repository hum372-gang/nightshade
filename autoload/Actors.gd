extends Node

var actor_positions: Dictionary = {}
var actors_present: Array[String] = []

signal actor_entered(name: String)

func applicable(directive):
	match [directive.verb, directive.body]:
		[["Appears"], _]: return true
		[["Enters"], _]: return true
		[["Exit"], _]: return true
		[["Controls"], ["yes"]]: return true
		[["Controls"], ["no"]]: return true
		[["Move", var a], [var l]] when get_actor(a) != null and get_landmark(l) != null: return true
		_: return false

func directive(directive):
	match [directive.verb, directive.body]:
		[["Appears"], [var actor]]: appears(actor, "default")
		[["Appears"], [var actor, var landmark]]: appears(actor, landmark)
		[["Enters"], [var actor]]: enters(actor, "default")
		[["Enters"], [var actor, var landmark]]: enters(actor, landmark)
		[["Move", var actor], [var landmark]]: moves(actor, landmark)
		[["Controls"], [var arg]]: controls(arg == "yes")


func _ready():
	Inkleton.subscribe(applicable, directive, self)

func mk_actor(name: String):
	var actor: PackedScene = load("res://actor/"+name+".tscn")
	if !actor:
		actor = load("res://actor/Fallback.tscn")
	var actor_node = actor.instantiate()
	actor_node.id = name
	return actor_node

func get_actor(name: String):
	var actors = get_tree().get_nodes_in_group("Actor")
	for actor in actors:
		if actor.id == name:
			return actor
	return null

func get_landmark(name: String) -> Node2D:
	var landmarks = get_tree().get_nodes_in_group("Landmark")
	for landmark in landmarks:
		if landmark.id == name:
			return landmark
	if name == "default":
		return null
	return get_landmark("default")

func update_last_position(of_actor: String):
	actor_positions[of_actor] = SceneLoader.current_stage

func appears(actor_name: String, landmark_name: String):
	var landmark = get_landmark(landmark_name)
	if get_actor(actor_name) != null:
		get_actor(actor_name).global_position = landmark.global_position
		return
	update_last_position(actor_name)
	var actor = mk_actor(actor_name)
	actor.global_position = landmark.global_position
	actors_present.push_back(actor_name)
	get_tree().current_scene.add_child(actor)
	actor_entered.emit(actor_name)
	return actor

func enters(actor_name: String, landmark_name: String):
	if get_actor(actor_name) != null:
		return
	var door: Door
	var last_room = actor_positions.get(actor_name, false)
	if last_room:
		for _door in get_tree().get_nodes_in_group("Door"):
			if _door.room == last_room:
				door = _door
				break;
	var spawn_point: String = door.get_node("%Exit").id if door else landmark_name
	var goal: String = door.get_node("%Entrance").id if door else landmark_name
	var actor = appears(actor_name, spawn_point)
	var unblock = Inkleton.block(actor)
	if goal:
		await moves(actor_name, goal)
	unblock.call()

func moves(actor_name: String, goal_name: String):
	var actor: Actor = get_actor(actor_name)
	var goal: Landmark = get_landmark(goal_name)
	var unblock = Inkleton.block(actor)
	await actor.move_to(goal.global_position)
	unblock.call()

func controls(setting: bool):
	var player = get_actor("P")
	if !player:
		return
	if setting:
		player.unblock()
	else:
		player.block()


## Called when the node enters the scene tree for the first time.
#func _ready():
	#Inkleton.directive.connect(directive)
	#SceneLoader.change_scene.connect(change_scene)
#
#func change_scene(_from, _to):
	#actors_present = []
#
#func directive(type: String, body: String, tags: PackedStringArray):
	#match type.to_lower():
		#"appears":
			#var parts = body.split(" ", false, 2)
			#var actor_name = parts[0]
			#var landmark_name = parts[1]
			#appears(actor_name, landmark_name)
		#"enters":
			#var parts = body.split(" ", false, 2)
			#var actor_name = parts[0]
			#var landmark_name = parts[1] if len(parts) > 1 else "Landmark"
			#enters(actor_name, landmark_name)
		#"exit":
			#exit(body)
		#"moves":
			#var parts = body.split(" ", false, 2)
			#var actor_name = parts[0]
			#var goal_name = parts[1]
			#moves(actor_name, goal_name)
		#"controls":
			#controls(body)
#
#
#
#
#
#func appears(actor_name: String, landmark_name: String):
	#var landmark = get_landmark(landmark_name)
	#if actor_name in actors_present:
		#get_actor(actor_name).global_position = landmark.global_position
	#update_last_position(actor_name)
	#var actor = mk_actor(actor_name)
	#actor.global_position = landmark.global_position
	#actors_present.push_back(actor_name)
	#get_tree().current_scene.add_child(actor)
#
#func enters(actor_name: String, landmark_name: String):
	#if actor_name in actors_present:
		#return
	#var door: Door
	#var last_room = actor_positions.get(actor_name, false)
	#if last_room:
		#for _door in get_tree().get_nodes_in_group("Door"):
			#if _door.room == last_room:
				#door = _door
				#break;
	#var spawn_point: String = door.get_node("%Exit").id if door else landmark_name
	#var goal: String = door.get_node("%Entrance").id if door else landmark_name
	#Inkleton.block()
	#appears(actor_name, spawn_point)
	#if goal:
		#await moves(actor_name, goal)
	#Inkleton.unblock()
	#pass
#
#func exit(exit_name: String):
	#var door: Door
	#for _door in get_tree().get_nodes_in_group("Door"):
		#if _door.choice_name == exit_name:
			#door = _door
	#if !door:
		#return
	#var exit: Landmark = door.get_node("%Exit")
	#Inkleton.block()
	#await moves("P", exit.id)
	#Inkleton.unblock()
#
#func controls(setting: String):
	#var player = get_actor("P")
	#if !player:
		#return
	#match setting.to_lower():
		#"yes", "on", "true":
			#player.unblock()
		#"no", "off", "false":
			#player.block()
		#_:
			#print("Error: weird controls setting")
