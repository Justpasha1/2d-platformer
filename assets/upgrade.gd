extends StaticBody2D

@export_enum('double_jump','dash') var type
@export var upgrade : GDScript



func _on_hit_box_body_entered(body):
	match  type:
		0:
			body.double_jump = upgrade
		1:
			body.dash = true
			#body.dash.added(body)
			body.emit_signal('dash_added')
			body.dash_meter.visible = true
			body.dash_meter.value = 100
	queue_free()
