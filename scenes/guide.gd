extends Control

signal typeSelected

@export var brain: Node2D
@onready var region_info: Dictionary

@export var type_dropdown: OptionButton
@export var description_label: RichTextLabel
@export var scale_factor: float = 1

# Tooltip variables
@export var tooltip_container: PanelContainer
@onready var tooltip_node := tooltip_container.get_node("SummaryTooltip")
@export var tooltip_offset: Vector2 = Vector2(20,10)

# Pause Menu Variables
@onready var pause_overlay: PanelContainer = $PauseOverlay

# RegionOverlay Variables
@onready var region_overlay: PanelContainer = $RegionDescriptionOverlay
@export var desc_container: VBoxContainer
@onready var title_text = desc_container.get_node("Title")
@onready var summary_text = desc_container.get_node("Summary")
@onready var desc_text = desc_container.get_node("Body")

#State Chart Variables
@onready var state_chart:StateChart = $StateChart

#Tab Bar Variables
@export var tab_container:TabContainer




@export var cursor: Sprite2D


var timePassed = 0

func _ready():
	#tab_container.set_tab_hidden(1,true)
	region_overlay.visible = false
	type_dropdown.add_item("None")
	for type in brain.types:
		type_dropdown.add_item(type)
	

func loadDescriptionText():
	description_label.visible_ratio = 0
	timePassed = 0
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _draw():
	#draw_circle(Vector2(0,0),150,Color.RED)
	pass


# NOTE: Anything that should happen every tick no matter what the state goes here.

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	
	var mouse_position: Vector2 = get_global_mouse_position()
	tooltip_container.position = Vector2(mouse_position.x + tooltip_offset.x,mouse_position.y+tooltip_offset.y)
	
func pause_game():
	Engine.time_scale = 0.0
	brain.process_mode = Node.PROCESS_MODE_DISABLED
func unpause_game():
	Engine.time_scale = 1.0
	brain.process_mode = Node.PROCESS_MODE_ALWAYS
# State Processing Functions
# NOTE: Anything that should only happen every tick depending on state goes here.

func _unpaused_process(_delta):
	pass

func _paused_process(_delta):
	pass


# State Input Functions
# NOTE: Any events that should be listened to depending on state goes here.

func _unpaused_input(_event):
	if Input.is_action_just_pressed("pause"):
		state_chart.send_event.call_deferred("to_pause")
	if brain.is_mouse_in_brain_area():
		if(_event is InputEventMouseButton and _event.pressed == true):
			print("Brain clicked.")
			region_info = brain.get_region_info(brain.hovered[1].name)
			print(region_info["summary"])
			state_chart.send_event.call_deferred("to_region")
		if(_event is InputEventMouseMotion):
			#TODO: Implement a better way to handle UI changes.
			
			var hovered_region = brain.handle_region_hover()
			if hovered_region[0]:
				tooltip_container.visible = true
				tooltip_node.text = hovered_region[1].name
			else:
				tooltip_container.visible = false
	else:
		tooltip_container.visible = false


func _paused_input(_event):
	tooltip_container.visible = false
	if Input.is_action_just_pressed("select"):
		# send event to unpause
		#state_chart.send_event.call_deferred("to_none")
		print("Cannot select right now")
	if Input.is_action_just_pressed("pause"):
		state_chart.send_event.call_deferred("to_none")


func _on_types_item_selected(index):
	emit_signal("typeSelected",type_dropdown.get_item_text(index))
	

func _on_unpause():
	unpause_game()
	pause_overlay.visible = false
	pass # Replace with function body.


func _on_pause():
	pause_game()
	pause_overlay.visible = true
	pass # Replace with function body.



func _on_unselect():
	unpause_game()
	region_overlay.visible = false
	pass # Replace with function body.

func _on_select():
	pause_game()
	# TODO: Figure out why this didn't work
	title_text = region_info["name"]
	summary_text = region_info["summary"]
	desc_text = region_info["description"]
	region_overlay.visible = true
	pass # Replace with function body.

