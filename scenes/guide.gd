extends Control

signal typeSelected

@export var region_info: Node2D


@export var type_dropdown: OptionButton
@export var description_label: RichTextLabel
@export var scale_factor: float = 1


var timePassed = 0

func _ready():
	type_dropdown.add_item("None")
	for type in region_info.types:
		type_dropdown.add_item(type)
	

func loadDescriptionText():
	description_label.visible_ratio = 0
	timePassed = 0
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	get_tree().root.content_scale_factor = scale_factor
	if description_label.visible_ratio < 1:
		description_label.visible_ratio = timePassed
		timePassed += delta *0.9


func _on_types_item_selected(index):
	emit_signal("typeSelected",type_dropdown.get_item_text(index))
	


func _on_brain_regions_ready():
	#print(region_info.getRegionByName("F7"))
	description_label.text = region_info.getRegionDescription("F7")




func _on_brain_region_selected(region):
	description_label.text = region_info.getRegionDescription(region)
	pass # Replace with function body.
