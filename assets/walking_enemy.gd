extends CharacterBody2D


@export var SPEED = 250.0
@export var acceleration = 100
@export var friction = 200

@onready var left_detect = $leftDetect
@onready var right_detect = $rightDetect

var alive = true

func _physics_process(delta):
	#print(typeof(scale))
	if alive:
		var direction
		if left_detect.is_colliding():
			if left_detect.get_collider(0).is_in_group('player'):
				direction = -1
		elif right_detect.is_colliding():
			if right_detect.get_collider(0).is_in_group('player'):
				direction = 1
		else:
			direction = 0
		
		if direction:
			velocity.x = direction*SPEED #lerp(velocity.x, direction * SPEED, delta*acceleration)
		else:
			velocity.x = 0 #move_toward(velocity.x, 0, delta*friction)
	if $hitBox.is_colliding():
		if $hitBox.get_collider(0).is_in_group('player') and alive:
			velocity.x = 0
			alive = false
			died()
	if !is_on_floor():
		velocity.y += 200 /2 *delta
	move_and_slide()
	

func died():
	$collisionAtack.queue_free()
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'scale', Vector2(2, 0.5), 0.1)
	#print(scale)
	
	await tween.finished
	
	queue_free()
