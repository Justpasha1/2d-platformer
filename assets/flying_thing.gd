extends CharacterBody2D

var Global_vel

@export var movement_speed = 2.0
@export var navigation : NavigationAgent2D

@onready var hitbox = $hitBox

var alive = true

var target

var movement_delta : float

#func set_target(movement_target):
	#navigation.set_target_position(movement_target.position)

func _physics_process(delta):
	##if navigation.navigation_finished:
		##print(1)
		##return
	#
	#movement_delta = movement_speed * delta
	#var next_path_position : Vector2 = navigation.get_next_path_position()
	#var new_velocity : Vector2 = global_position.direction_to(next_path_position)
	#if navigation.avoidance_enabled:
		#print(1)
		#navigation.set_velocity(new_velocity)
	#else:
		#print(2)
		#_on_navigation_agent_2d_velocity_computed(new_velocity)
	#print(navigation.is_target_reachable())
	#move_and_slide()
	if $hitBox.is_colliding():
		if hitbox.get_collider(0).is_in_group('player') and alive:
			velocity.x = 0
			alive = false
			died()
	if alive:
		if target:
			var dir = to_local(navigation.get_next_path_position())
			velocity = dir * movement_speed
			print(velocity)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	


#func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#global_position = global_position.move_toward(global_position+safe_velocity, movement_delta)
	#move_and_slide()

func upd_path():
	navigation.target_position = target.global_position

func _on_detection_body_entered(body):
	print(body)
	if body.is_in_group('player'):
		target = body

func died():
	$collisionAttack.queue_free()
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'scale', Vector2(2, 0.5), 0.1)
	#print(scale)
	
	await tween.finished
	
	queue_free()

func _on_timer_timeout():
	if target:
		upd_path()


func _on_last_detect_body_exited(body):
	if target:
		target = null
