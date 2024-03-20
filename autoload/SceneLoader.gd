extends Node

var current_stage = ""

signal change_scene(from: String, to: String)

func applicable(directive):
	match directive.verb:
		[var v] when v.to_lower() == "scene": return true
		_: return false

func _ready():
	Inkleton.subscribe(applicable, func(d): change_scene_to(d.body[0]), self)

#func directive(type: String, body: String, _tags: PackedStringArray):
	#if type.to_lower() != "scene":
		#return
	#if body == current_stage:
		#return
	#Inkleton.block()
	#var path = "res://scene/"+body+".tscn"
	#ResourceLoader.load_threaded_request(path, "PackedScene", true, ResourceLoader.CACHE_MODE_REUSE)
	#while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		#await get_tree().process_frame
	#if ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_LOADED:
		#print("Load of "+path+" failed with "+str(ResourceLoader.load_threaded_get_status(path)))
		#Inkleton.unblock()
		#return
	#var old = current_stage
	#current_stage = body
	#var scene: PackedScene = ResourceLoader.load_threaded_get(path);
	#get_tree().change_scene_to_packed(scene)
	#change_scene.emit(old, body)
	#await get_tree().process_frame
	#Inkleton.unblock()

func change_scene_to(name: String):
	var unblock = Inkleton.block(self)
	var path = "res://scene/"+name+".tscn"
	ResourceLoader.load_threaded_request(path, "PackedScene", true, ResourceLoader.CACHE_MODE_REUSE)
	while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	var scene: PackedScene
	if ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_LOADED:
		print("Load of "+path+" failed with "+str(ResourceLoader.load_threaded_get_status(path)))
		scene = preload("res://scene/Fallback.tscn")
	else:
		scene = ResourceLoader.load_threaded_get(path);
	var old = current_stage
	current_stage = name
	get_tree().change_scene_to_packed(scene)
	change_scene.emit(old, current_stage)
	await get_tree().process_frame
	await get_tree().process_frame
	unblock.call()
