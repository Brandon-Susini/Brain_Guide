extends CanvasGroup

@onready var brain_offset: Vector2 = position
@onready var collision_shape = $O2.polygon

func _ready():
	for i in range(len(collision_shape)):
		print("Before -> ", collision_shape[i])
		collision_shape.set(i,collision_shape[i] + ($O2.position)) #+ brain_offset))
		print("After -> ", collision_shape[i])
	print("Brain Offset:")
	print(brain_offset)
	print("Collision Shape:")
	print(collision_shape)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Geometry2D.is_point_in_polygon(get_global_mouse_position(),collision_shape):
		$O2.color = Color.PURPLE
		#print("Something")
	else:
		$O2.color = Color.WHITE
	pass
