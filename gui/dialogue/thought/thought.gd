extends CharacterBody2D

@export var text: String
@export var target: Node2D
@export var tags: PackedStringArray
@export var desired_relative: Vector2 = Vector2(32, 8)
@onready var label: RichTextLabel = %RichTextLabel

func _ready():
	self.modulate = Color.TRANSPARENT
	label.text = text
	label.visible_characters = 0
	global_position = target.global_position + Vector2(1,1)

func run():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	tween.play()
	for i in range(len(text)+1):
		label.visible_characters = i;
		await get_tree().process_frame
	await get_tree().create_timer(2).timeout
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	tween.play()
	await tween.finished

func _process(delta):
	if !target:
		return;
	var to_target = target.global_position - global_position + desired_relative
	var distance_error = to_target.length() - 3
	if to_target == Vector2.ZERO:
		to_target = Vector2.RIGHT
	var correction = to_target.normalized() * distance_error
	global_position += correction * 0.1
