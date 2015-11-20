
extends TextureButton

var popup = preload('building_popup.xml')

var window = null

class Building:
	var name = ""
	var level = 0
	var description = "This is a generic building.\n\n  This is words that describe the building you are mousing over right now!\n If enough text exists here, it should scroll freely.\n Really, there is no limit to how long you can make this fucker!"
	
	var cost_factor = 1.75
	var production_factor = 1.55
	
	var base_production = {
			'population':	5
			}
	
	var base_cost = {
		'metal': 	100,
		'crystal':	50,
		'nanium':	0,
		'tech':		0
			}
	
	func get_cost(L):
		var cost = {
			'metal':	self.base_cost['metal'] * ceil(self.cost_factor * L),
			'crystal':	self.base_cost['crystal'] * ceil(self.cost_factor * L),
			'nanium':	self.base_cost['nanium'] * ceil(self.cost_factor * L),
			'tech':		self.base_cost['tech'] * ceil(self.cost_factor * L)
				}
		return cost
	
	func get_production(asset,L):
		var value = null
		if self.base_production.has(asset):
			value = self.base_production[asset] * ceil(self.production_factor * L)
		return value
	
	func _set_name(name):
		self.name = name
	func _get_name():
		return self.name
	
var building

func _ready():
	building = Building.new()

func set_building_name(name):
	if building:
		building._set_name(name)
		print(str("name set to ",get_building_name()))
		
func get_building_name():
	if building:
		return building._get_name()
	return "building Name not found!"

func draw_button():
	if building:
		print("drew button")
		get_node('name').set_text(get_building_name())
		get_node('level').set_text(str("Level ",str(building.level)))



func _on_Button_mouse_enter():
	var P = popup.instance()
	P.set_pos(get_viewport().get_mouse_pos())
	get_node('/root').add_child(P)
	var C = building.get_cost(building.level+1)
	P._on_PopupPanel_about_to_show(building.name,building.level,building.description,C)
	P.popup()
	window = P

func _on_Button_mouse_exit():
	if window != null:
		window.queue_free()
		window = null
