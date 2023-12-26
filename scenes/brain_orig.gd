extends CanvasGroup


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Geometry2D.is_point_in_polygon(get_global_mouse_position(),$O2.polygon):
		$O2.color = Color.PURPLE
		print("Something")
	else:
		$O2.color = Color.WHITE
	pass
