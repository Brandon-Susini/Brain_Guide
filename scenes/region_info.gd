extends CanvasGroup

signal itemSelected
@export var types = [
	"NeTi",
	"NeFi",
	"FiSe",
	"FiNe",
	"TiNe",
	"TiSe",
	"FeSi",
	"FeNi",
	"TeSi",
	"TeNi",
	"NiFe",
	"NiTe",
	"SiFe",
	"SiTe",
	"SeFi",
	"SeTi",
]

@export var intensity = {
	"NeTi": [
		["F3", "F4", "C3", "P3"],
		["F8", "T5", "T6", "O1"],
		["C4", "T4", "O2", "Fp1"],
		["Fp2", "F7", "T3", "P4"],
	],
	"NeFi": [
		["F3", "F4", "C3", "C4"],
		["T3", "P3", "P4", "O1"],
		["Fp1", "F8", "T5", "T6"],
		["Fp2", "F7", "T4", "O2"],
	],
	"FiSe": [
		["F3", "F4", "C3", "P4"],
		["F7", "P3", "C4", "T5"],
		["Fp2", "T3", "T4", "F8"],
		["Fp1", "O1", "O2", "T6"],
	],
	"FiNe": [
		["F3", "F4", "P3", "P4"],
		["O1", "C4", "C3", "T5"],
		["Fp2", "F7", "T6", "O2"],
		["Fp1", "F8", "T3", "T4"],
	],
	"TiNe": [
		["T4", "P3", "T5", "O2"],
		["T3", "C4", "P4", "T6"],
		["Fp2", "F7", "F8", "O1"],
		["Fp1", "F3", "F4", "C3"],
	],
	"TiSe": [
		["F3", "F4", "C3", "C4"],
		["F7", "F8", "T4", "T5"],
		["Fp2", "T3", "T6", "O1"],
		["Fp1", "P3", "O2", "P4"],
	],
	"FeSi": [
		["T4", "P3", "P4", "O2"],
		["F3", "F4", "C4", "F8"],
		["Fp2", "C3", "T6", "O1"],
		["Fp1", "F7", "T5", "T3"],
	],
	"FeNi": [
		["F3", "F4", "P3", "O1"],
		["F7", "F8", "C3", "P4"],
		["Fp2", "T4", "T6", "O2"],
		["Fp1", "T3", "C4", "T5"],
	],
	"TeSi": [
		["F4", "P3", "P4", "C4"],
		["T4", "T5", "T6", "O2"],
		["Fp2", "F7", "T3", "F3"],
		["Fp1", "F8", "C3", "O1"],
	],
	"TeNi": [
		["F7", "T5", "F3", "P3"],
		["F4", "C4", "P4", "T6"],
		["Fp2", "C3", "T4", "O2"],
		["Fp1", "F8", "T3", "O1"],
	],
	"NiFe": [
		["F3", "C3", "P3", "P4"],
		["F4", "C4", "T4", "O2"],
		["Fp1", "F7", "T5", "T6"],
		["Fp2", "F8", "T3", "O1"],
	],
	"NiTe": [
		["F3", "F4", "P3", "C4"],
		["F8", "C3", "T5", "P4"],
		["Fp1", "F7", "T4", "O2"],
		["Fp2", "T3", "T6", "O1"],
	],
	"SiFe": [
		["F7", "F4", "F8", "P4"],
		["F3", "C3", "P3", "T6"],
		["Fp1", "T3", "T4", "O1"],
		["Fp2", "C4", "T5", "O2"],
	],
	"SiTe": [
		["F4", "C3", "C4", "P4"],
		["F3", "T3", "T4", "T6"],
		["Fp1", "F7", "P3", "O2"],
		["Fp2", "F8", "T5", "O1"],
	],
	"SeFi": [
		["F3", "F4", "P4", "T5"],
		["T3", "P3", "T6", "O2"],
		["Fp1", "C3", "C4", "O1"],
		["Fp2", "F7", "F8", "T4"],
	],
	"SeTi": [
		["C3", "C4", "T5", "F8"],
		["F7", "T4", "T6", "O1"],
		["Fp1", "T3", "P3", "O2"],
		["Fp2", "F3", "F4", "P4"],
	],
}

var regions: Array[Node]
var color = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	color['blue'] = Color(0,0,255,1)
	color['green'] = Color(0,255,0,1)
	color['yellow'] = Color(247,225,0)
	color['red'] = Color(255,0,0,1)
	regions = get_children()
	resetRegionColors()
	changeRegionColor("NeTi")
	#cycle_intensity()
	


func cycle_intensity():
	var count = 0
	for region in regions:
		if count % 2 == 0:
			region.color = color['red']
		else:
			region.color = color['yellow']
		count +=1
		await get_tree().create_timer(1.0).timeout
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func changeRegionColor(type:String):
	var activity = intensity[type]
	var activity_legend = {}
	for i in range(len(activity)):
		for region in activity[i]:
			var r = getRegionByName(region)
			r.color = color.keys()[i]
			await get_tree().create_timer(0.05).timeout
		pass
	pass


func resetRegionColors():
	for region in regions:
		region.color = Color.BLACK

func getRegionByName(region:String):
	for r in regions:
		if r.name == region:
			return r
	return null

func _on_types_item_selected(index):
	print("Selected: ", types[index])
	resetRegionColors()
	changeRegionColor(types[index])
	emit_signal("itemSelected",intensity[types[index]])
	
	

