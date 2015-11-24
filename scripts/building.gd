
extends TextureButton

var popup = load('res://building_popup.xml')

var window = null




class Building:
	var name = ""
	var level = 0
	var description = """This is a generic building.\n\n  
	This is words that describe the building you are mousing over right now!\n 
	If enough text exists here, it should scroll freely.\n 
	Really, there is no limit to how long you can make this fucker!"""
	
	var cost_factor = 1.75
	var production_factor = 1.55
	
	var base_production = {}
	
	var base_cost = {
		'metal': 	0,
		'crystal':	0,
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
			value = self.base_production[asset] * L
		return value
	
	func _set_name(name):
		self.name = name
		print(str("building name set to ",self.name))
	func _get_name():
		return self.name
	
	func _set_description(text):
		self.description = text
		print(self.description)
		
	func _get_description():
		return self.description
		
	func _add_production(asset,value):
		self.base_production[asset] = value


var building

func _ready():
	building = Building.new()

func set_building_name(name):
	if building:
		building._set_name(name)

func get_building_name():
	if building:
		return building._get_name()
	return "building Name not found!"

func get_building_level():
	if building:
		return building.level

func set_building_description(text):
	if building:
		building._set_description(text)
func get_building_description():
	if building:
		print(building.description)
		return building.description
		
func add_production(asset,value):
	if building:
		building._add_production(asset,value)

func set_cost(m,c,n,t):
	if building:
		building.base_cost = {
			'metal':	m,
			'crystal':	c,
			'nanium':	n,
			'tech':		t}


func draw_button():
	if building:
		get_node('name').set_text(get_building_name())
		get_node('level').set_text(str("Level ",str(building.level)))



func _on_Button_mouse_enter():
	var P = popup.instance()
	P.set_pos(get_viewport().get_mouse_pos())
	get_node('/root').add_child(P)
	var C = building.get_cost(building.level+1)
	P._on_PopupPanel_about_to_show(get_building_name(),get_building_level(),get_building_description(),C)
	P.popup()
	window = P

func _on_Button_mouse_exit():
	if window != null:
		window.queue_free()
		window = null
