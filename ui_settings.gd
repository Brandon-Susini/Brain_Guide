extends Node
class_name UISettings

signal update_ui

# Grey Color Value: b1b1b1
@onready var text_bg_color: Color
@onready var last_bg_color = text_bg_color
@export var menu_items: Array[Node]


func _on_bg_color_changed(_color:Color):
	emit_signal("update_ui")


func get_bg_color():
	return menu_items[0].color
