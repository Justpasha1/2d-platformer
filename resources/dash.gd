extends Resource

static var can_dash = true
static var dash_power = 300
static var cooldown = 2
static var dashing = false

static var time
#static func added(body,timer):
	#
	#time = Timer.new()
	#time.wait_time = cooldown
	##time.autostart = false
	##time.one_shot = true
	#
	#body.add_child(time)

static func dash(body, timer, dir,dash_timer):
	if Input.is_action_just_pressed('dash') and can_dash and body.velocity.x != 0: 
		dashing = true
		
		can_dash = false
		timer.start()
		dash_timer.start()
		
	if dashing:
		print(1)
		body.velocity.x += dir * dash_power 
		
#
#static func _on_cooldown_end():
	#can_dash = true
