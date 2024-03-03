extends CharacterBody2D


var can_dash = true
var dash_power = 500
var cooldown = 2
var dashing = false

@export var max_hp = 4
@onready var hp = max_hp

@export var ghost_node : PackedScene
@export var maxSPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var acceleration = 100
@export var friction = 600
@export var knockback_power = 200.0

var double_jump : GDScript
var dash 

var taking_damage = false
var damage_side
var can_move = true

@onready var timer = $cooldown
@onready var dash_time = $dashingTime
@onready var dash_meter = $camera/dash_meter



signal dash_added

func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $sprite2.scale)
	get_tree().current_scene.add_child(ghost)

func _physics_process(delta):
	if double_jump:
		double_jump.double_jump(self)
	
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += JUMP_VELOCITY * -3 * delta
			#print(position.y, "y")
			#print(velocity.y, 'velocity')
		elif velocity.y >= 0: 
			#print(1)
			velocity.y -= JUMP_VELOCITY * 3 * delta
			
			#velocity = velocity.clamp(JUMP_VELOCITY, JUMP_VELOCITY*-1)
			#print(velocity," - limited")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if dash:
		if Input.is_action_just_pressed('dash') and can_dash and direction != 0: 
			dashing = true
			#dash_meter.value = 0
			can_dash = false
			timer.start()
			dash_time.start()
			
	if !can_dash:
		print(timer.time_left, " - time left")
		dash_meter.value = 100 - timer.time_left * 100
		print(dash_meter.value)
		
	if taking_damage:
		velocity.x = damage_side * -1 * knockback_power
	if can_move:
		if direction:
			if dashing:
				#print(1)
				add_ghost()
				velocity.x = direction * dash_power
				velocity.y = 0 
			else:
				velocity.x =   lerp(direction, direction*maxSPEED, delta*acceleration)       #direction * SPEED
		else:
			#if velocity.length() > (friction*delta):
			velocity.x = move_toward(velocity.x, 0, delta*friction)
			#else:
				#velocity.x = 0
	velocity.normalized()
	#bounce(velocity)
	move_and_slide()

func _on_cooldown_end():
	dash_meter.value = 100
	can_dash=true

func _dash_ended():
	dashing = false

#func bounce(velocity:Vector2):
	##print(velocity.y)
	#if velocity.y == 0:
		#print('not bounce')
		#$sprite.scale.x = 1
	#elif velocity.y > 0 or velocity.y < 0:
		#print('bounce')
		##velocity = velocity.clamp(Vector2(0,0.50),Vector2(0,1.5))
		##print(velocity)
		#$sprite.scale.x = 0.50

func _on_dash_added():
	timer.connect('timeout',_on_cooldown_end)
	dash_time.connect('timeout',_dash_ended)


func _on_hit_box_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group('enemy'):
		took_damage(body)
func took_damage(body):
	hp -= 1
	if hp == 0:
		get_tree().quit()
	%hp.frame_coords.x += 1
	modulate = Color(1,0,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'modulate', Color(1,1,1), 0.25)
	
	if body.global_position.x < global_position.x:
		damage_side = -1
	elif body.global_position.x > global_position.x:
		damage_side = 1
	can_move = false
	taking_damage = true
	$knockbackTime.start()


func _on_knockback_time_timeout():
	can_move = true
	taking_damage = false
