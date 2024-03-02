extends Node

@export var target_actor: Node2D
@export var max_fraction: float = 1.0

@onready var tween = get_tree().create_tween()

func _ready():
	tween.set_parallel(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_pointer()
	pass

func change_target(to: Node2D):
	if !tween:
		return
	if target_actor == to:
		return
	tween.kill()
	tween = create_tween()
	var prev = target_actor
	if prev == null:
		target_actor = to
		set_process(true)
		%Control.show()
		tween.tween_property(%Control, "modulate", Color.WHITE, 0.25)
		tween.tween_property(self, "max_fraction", 1.0, 0.5)
		tween.play()
		await tween.finished
	elif to == null:
		tween.tween_property(self, "max_fraction", 0.0, 0.25)
		tween.tween_property(%Control, "modulate", Color.TRANSPARENT, 0.5)
		tween.play()
		await tween.finished
		%Control.hide()
		target_actor = to
	else:
		tween.tween_property(self, "max_fraction", 0.0, 0.25)
		tween.tween_callback(func(): target_actor = to)
		tween.tween_property(self, "max_fraction", 1.0, 0.5)
		tween.play()
		await tween.finished

func update_pointer():
	if target_actor == null:
		return
	var position = target_actor.get_global_transform_with_canvas().origin - %Path2D.global_position
	%Path2D.curve.set_point_position(1, position)
	%Line2D.clear_points()
	var path_progress = 0
	while true:
		var point = %Path2D.curve.sample(0, path_progress)
		%Line2D.add_point(point)
		path_progress += 0.01
		if point.distance_to(position) < 64 or path_progress > max_fraction:
			break

func handle_message(actor: String, text: String, _tags: Array[String]):
	var actor_node = Actors.get_actor(actor)
	change_target(actor_node)
	%RichTextLabel.text = text
	if "remark" in _tags:
		%Button.hide()
	else:
		%Button.show()
	for i in range(len(text)+1):
		%RichTextLabel.visible_characters = i
		await get_tree().process_frame
	if "remark" in _tags:
		await get_tree().create_timer(1.5).timeout
	else:
		await %Button.pressed
