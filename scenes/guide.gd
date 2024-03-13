extends Control

signal typeSelected

@export var brain: Node2D
@onready var region_info: Dictionary

@export var type_dropdown: OptionButton

@export var description_label: RichTextLabel
@export var scale_factor: float = 1

# Tooltip variables
@export var tooltip_container: PanelContainer
@onready var tooltip_node := tooltip_container.get_node("MarginContainer/SummaryTooltip")
@onready var tooltip_background = tooltip_container.get_node("TooltipBG")
@export var tooltip_offset: Vector2 = Vector2(20,10)

# Pause Menu Variables
@onready var pause_overlay:PanelContainer = $PauseOverlay

# RegionOverlay Variables
@onready var region_overlay: PanelContainer = $RegionDescriptionOverlay
@onready var scroll_container: ScrollContainer = region_overlay.get_node("MarginContainer/ScrollContainer")
@export var desc_container: VBoxContainer
@onready var title = desc_container.get_node("Title")
@onready var summary = desc_container.get_node("Summary")
@onready var desc = desc_container.get_node("Body")


@onready var pause_overlay_background = $PauseOverlay/MarginContainer/PauseOverlayBG
@onready var region_overlay_background = $RegionDescriptionOverlay/MarginContainer/RegionDescriptionBG

#State Chart Variables
@onready var state_chart:StateChart = $StateChart

#Tab Bar Variables
@export var tab_container:TabContainer

#Brain Background Rect
#@onready var brain_bg: CanvasItem # Depreciated, may be able to use color rect instead for more options.
@onready var brain_color_rect: CanvasItem
# @export var change_amt = 1
# @export var mod_limit = 1000

@export var available_backgrounds:Array[Shader]
@onready var bg_index = 1

# Resource
@onready var ui_settings := $UISettings

@export var cursor: Sprite2D

@onready var hover_info := [false,null]


var showingTooltip = false

var timePassed = 0


func get_random_point():
	return Vector3(snapped(randf_range(0.1,0.9),0.1),snapped(randf_range(0.1,0.9),0.1),snapped(randf_range(0.1,0.9),0.1))

# Function Depreciated
func update_brain_bg(index):
	# TODO: Set the current shader property of brain bg's material to the next shader in available_bgs array.
	#brain_bg.material.shader = available_backgrounds[index]
	pass

func _update_ui():
	for bg in get_tree().get_nodes_in_group("bg_rect"):
		bg.color = ui_settings.get_bg_color()
		pass


func _ready():
	#brain_bg = find_child("BrainBG")
	brain_color_rect = find_child("BrainColorBG")
	# brain_color_rect.use_parent_material = true # Use this code to show static color instead of shader.
	#tab_container.set_tab_hidden(1,true)
	region_overlay.visible = false
	for type in brain.types:
		type_dropdown.add_item(type)
	_update_ui()
	
	


func loadDescriptionText():
	description_label.visible_ratio = 0
	timePassed = 0
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _draw():
	#draw_circle(Vector2(0,0),150,Color.RED)
	pass

func set_region_info(hovered_region: Polygon2D):
	region_info = brain.get_region_info(hovered_region.name)


func update_tooltip(local_hover_info):
	tooltip_node.text = ""
	tooltip_container.size = Vector2.ZERO
	set_region_info(local_hover_info[1])
	var text = "[b]" + region_info["name"] + "[/b]\n-------[ul]\n"
	for line in region_info["summary"]:
		text += line + "\n"
	text += "[/ul]"
	tooltip_node.text = text		
	pass

func hide_tooltip():
	tooltip_container.visible = false
	

func show_tooltip():
	tooltip_container.visible = true


func _check_mouse_move():
	
	#TODO: Implement a better way to handle UI changes.
	if(region_info.is_empty() and hover_info[0]):
		update_tooltip(hover_info)
	elif(!region_info.is_empty() and hover_info[0]):
		if(hover_info[1].name != region_info["name"]):
			update_tooltip(hover_info)
		else:
			if(!tooltip_container.visible):
				show_tooltip()
	else:
		if(tooltip_container.visible):
			hide_tooltip()


# NOTE: Anything that should happen every tick no matter what the state goes here.

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	
	var mouse_position: Vector2 = get_global_mouse_position()
	if brain.is_mouse_in_brain_area():
		tooltip_container.position = Vector2(mouse_position.x + tooltip_offset.x,mouse_position.y+tooltip_offset.y)
	

# State Processing Functions
# NOTE: Anything that depends on state goes here and happens every tick goes here.

func _unpaused_process(_delta):
	# var o = brain_bg.texture.noise.offset
	# var new_offset = Vector3(fmod(o.x + (change_amt * _delta),mod_limit),fmod(o.y + (change_amt * _delta),mod_limit),fmod(o.z + (change_amt * _delta),mod_limit))
	# brain_bg.texture.noise.offset = new_offset
	# print(new_offset)
	pass

func _paused_process(_delta):
	pass


# State Input Functions
# NOTE: Any events that should be listened to depending on state goes here.

func _unpaused_input(_event):
	if Input.is_action_just_pressed("pause"):
		state_chart.send_event.call_deferred("to_pause")
		return
	if Input.is_action_just_pressed("option"):
		print("option")
		#update_brain_bg(1)
	if brain.is_mouse_in_brain_area():
		if(Input.is_action_just_pressed("select")):
			hover_info = brain.handle_region_hover()
			if(hover_info[0]):
				set_region_info(hover_info[1])
				state_chart.send_event.call_deferred("to_region")
		
		if(_event is InputEventMouseMotion):
			hover_info = brain.handle_region_hover()
			_check_mouse_move()
			# elif(region_info == null and !hover_info[0]):
			# 	return
			# elif(hover_info[1].name != region_info["name"]):
			# 	update_tooltip(hover_info)
	else:
		if(tooltip_container.visible):
			hide_tooltip()
			


func _paused_input(_event):
	if Input.is_action_just_pressed("select"):
		# send event to unpause
		#state_chart.send_event.call_deferred("to_none")
		print("Cannot select right now")
	if Input.is_action_just_pressed("pause"):
		state_chart.send_event.call_deferred("to_none")


# func _on_types_item_selected(index):
# 	emit_signal("type_selected",type_dropdown.get_item_text(index))
	

func _on_unpause():
	unpause_game()
	pause_overlay.visible = false


func _on_pause():
	pause_game()
	showingTooltip = tooltip_container.visible
	tooltip_container.visible = false
	pause_overlay.visible = true

func pause_game():
	Engine.time_scale = 0.0
	brain.process_mode = Node.PROCESS_MODE_DISABLED
	


func unpause_game():
	Engine.time_scale = 1.0
	brain.process_mode = Node.PROCESS_MODE_ALWAYS
	_check_mouse_move()
	tooltip_container.visible = showingTooltip


func _on_unselect():
	unpause_game()
	region_overlay.visible = false
	scroll_container.scroll_vertical = 0
	pass # Replace with function body.

func _on_select():
	pause_game()
	
	# TODO: Figure out why this didn't work
	title.text = "[b]" + region_info["name"] +"[/b]"
	var summary_text = "[ul]"
	for line in region_info["summary"]:
		summary_text += line + "\n"
	summary_text += "[/ul]"
	summary.text = summary_text
	desc.text = region_info["description"]
	region_overlay.visible = true
	pass # Replace with function body.


func _on_brain_exited():
	hover_info = brain.handle_region_hover()
	hide_tooltip()


func _on_state_chart_ready():
	pass
