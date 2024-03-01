extends Node

var current_stage = ""

signal change_scene(from: String, to: String)

func _ready():
	Inkleton.directive.connect(directive)

func directive(type: String, body: String, _tags: PackedStringArray):
	if type.to_lower() != "scene":
		return
	if body == current_stage:
		return
	Inkleton.block()
	var path = "res://scene/"+body+".tscn"
	ResourceLoader.load_threaded_request(path, "PackedScene", true, ResourceLoader.CACHE_MODE_REUSE)
	while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	if ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_LOADED:
		print("Load of "+path+" failed with "+str(ResourceLoader.load_threaded_get_status(path)))
		Inkleton.unblock()
		return
	var old = current_stage
	current_stage = body
	var scene: PackedScene = ResourceLoader.load_threaded_get(path);
	get_tree().change_scene_to_packed(scene)
	change_scene.emit(old, body)
	await get_tree().process_frame
	Inkleton.unblock()
