
extends TextureButton



class Building:
	var name = "Loveshack"
	var level = 0
	var description = """This is a generic building.\n\n  
	This is words that describe the building you are mousing over right now!\n 
	You should have no more text than this."""
	
	var cost_factor = 1.75

	
	var base_production = {}
	
	var base_cost = {
		'metal': 	0,
		'crystal':	0,
		'nanium':	0,
		'tech':		0
			}
	
	func upgrade():
		#subtract costs
		#
		
		self.level += 1
	
	func cost_multiplier(L):
		return ceil(self.cost_factor * L + exp(L*0.33))
		
	func get_cost(L):
		var cost = {
			'metal':	self.base_cost['metal'] * cost_multiplier(L),
			'crystal':	self.base_cost['crystal'] * cost_multiplier(L),
			'nanium':	self.base_cost['nanium'] * cost_multiplier(L),
			'tech':		self.base_cost['tech'] * cost_multiplier(L)
				}
		return cost
	
	func get_production(asset,L):
		var value = null
		if self.base_production.has(asset):
			value = self.base_production[asset] * L
		return value

	func add_production(asset,value):
		self.base_production[asset] = value


var building

func draw_button():
	if building:
		get_node('name').set_text(building.name)
		get_node('level').set_text(str("Level ",str(building.level)))



func _on_Button_mouse_enter():
	get_node('Popup').popup()


func _on_Button_mouse_exit():
	get_node('Popup').hide()


func _on_Button_pressed():
	building.upgrade()
	draw_button()