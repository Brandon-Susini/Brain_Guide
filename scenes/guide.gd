extends Control

signal typeSelected

@export var region_info: Node2D


@export var type_dropdown: OptionButton
@export var description_label: RichTextLabel
@export var scale_factor: float = 1

#Tooltip variables
@export var summary_tooltip: PanelContainer
@export var tooltip_offset: Vector2 = Vector2(20,10)

#State Chart Variables
@onready var state_chart:StateChart = $StateChart

#Tab Bar Variables
@export var tab_container:TabContainer

var timePassed = 0

func _ready():
	#tab_container.set_tab_hidden(1,true)
	type_dropdown.add_item("None")
	for type in region_info.types:
		type_dropdown.add_item(type)
	

func loadDescriptionText():
	description_label.visible_ratio = 0
	timePassed = 0
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		state_chart.send_event.call_deferred("to_pause")
		
	var mouse_position: Vector2 = get_global_mouse_position()
	summary_tooltip.position = Vector2(mouse_position.x + tooltip_offset.x,mouse_position.y+tooltip_offset.y)
	get_tree().root.content_scale_factor = scale_factor
	if description_label.visible_ratio < 1:
		description_label.visible_ratio = timePassed
		timePassed += delta *0.9


func _on_types_item_selected(index):
	emit_signal("typeSelected",type_dropdown.get_item_text(index))
	


func _on_brain_regions_ready():
	#print(region_info.getRegionByName("F7"))
	#description_label.text = region_info.getRegionDescription("F7")
	pass




func _on_brain_region_selected(region):
	state_chart.send_event("to_region")
	#description_label.text = region_info.getRegionDescription(region)
	pass # Replace with function body.
