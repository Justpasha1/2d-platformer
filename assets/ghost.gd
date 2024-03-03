extends Sprite2D

func set_property(pos, scl):
	position = pos
	scale = scl

func ghost():
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, 'self_modulate', Color(0.243,0.043,0.243, 0), 0.5)
	
	await tween.finished
	
	queue_free()
func _enter_tree():
	ghost()
