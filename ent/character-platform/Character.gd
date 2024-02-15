extends CharacterBody2D

@export var coyote_time: float = 0.25;
@export var speed: float = 300.0
@export var jump_velocity: float = -300.0
@export var max_jump_time: float = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var new_jump = 0
var jump = false
var control = Vector2.ZERO
var coyote_timer = 0.0
var jump_hold_timer = 0.0

func _process(_delta):
	var driver = get_children().filter(func (c): return c is CharacterDriver)
	driver.sort_custom(func(a, b): return a.priority()>b.priority())
	if len(driver)>0:
		driver = driver[0]
		jump = driver.jump()
		control = driver.control()
		control = control.normalized() if control.length() > 1 else control

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	if jump and new_jump == 0:
		new_jump = 1
	elif jump and new_jump == 1:
		new_jump = 2
	elif !jump:
		new_jump = 0
	if (new_jump == 1 and (coyote_timer > 0)) or (new_jump == 2 && jump_hold_timer < max_jump_time && !is_on_floor()):
		velocity.y = jump_velocity
		coyote_timer = 0
		jump_hold_timer += delta
	if !jump and is_on_floor():
		jump_hold_timer = 0
	if !jump and !is_on_floor():
		jump_hold_timer = 99999

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = control.x
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
