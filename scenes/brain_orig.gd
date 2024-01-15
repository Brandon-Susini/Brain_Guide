extends CanvasGroup

@onready var brain_offset: Vector2 = position
@onready var region = $F7
@onready var collision_shape = region.polygon
@onready var poly1

func _ready():
	for i in range(len(collision_shape)):
		print("Before -> ", collision_shape[i])
		collision_shape.set(i,(collision_shape[i] + (region.position)) + brain_offset)
		print("After -> ", collision_shape[i])
	print("Brain Offset:")
	print(brain_offset)
	print("Collision Shape:")
	print(collision_shape)

	
	
	#poly1Decompose = Geometry2D.decompose_polygon_in_convex(collision_shape)
	#print(poly1)


#if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
#		if(Geometry2D.is_point_in_polygon(get_global_mouse_position(),poly1[0])):
#			print("Hello World")
#		else:
#			print("Dud")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.global_position = get_global_mouse_position()
	if Geometry2D.is_point_in_polygon(get_global_mouse_position(),collision_shape):
		region.color = Color.PURPLE
		#print("Something")
	else:
		region.color = Color.WHITE

	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		print("Local Mouse Position:")
		print(get_local_mouse_position())
	pass
