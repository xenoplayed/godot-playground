extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta: float) -> void:
	# check for input (e.g. WASD, configured in Project -> Project Settings... -> Input Map)
	# Note: positive y-values go down in the coordinate system, negative ones go up
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # normalize vector, otherwise walking diagonal would be faster as walking up or rig
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# Move in the given direction
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # prevents player from leaving screen

	# choose image and flip depending on direction
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		

func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after beeing hit
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

# reset player when starting new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
