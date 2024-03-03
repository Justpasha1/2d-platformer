extends  Resource

static var can_double_jump

static func double_jump(body):
	if !body.is_on_floor() and can_double_jump and Input.is_action_just_pressed("ui_accept"):
		body.velocity.y = body.JUMP_VELOCITY
		can_double_jump = false
	if body.is_on_floor() and !can_double_jump:
		can_double_jump = true
