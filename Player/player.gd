extends CharacterBody2D

const NORMAL_SPEED = 200.0
const JUMP_VELOCITY = -400.0
const dashspeed = 2500
const dashlength = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
@onready var dash = $Dash

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
	if velocity.y > 0:
			anim.play("Fall")
	if velocity.y == 0:
		anim.play("Run")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_backward", "move_forward")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		
	if direction:
		velocity.x = direction * NORMAL_SPEED
		if Input.is_action_just_pressed("dash"):
			dash.start_dash(dashlength)
			velocity.x = direction * dashspeed
	else:
		velocity.x = move_toward(velocity.x, 0, NORMAL_SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	
	move_and_slide()
	# if Game.playerHP <= 0:
		# queue_free()
		# get_tree().change_scene_to_file("res://main.tscn")
