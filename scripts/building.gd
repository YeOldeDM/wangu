
extends TextureButton

class EquipmentBuilding:
	var construction
	var bank
	var combat
	var name = "Equipment"
	var description = "This is equipment. It buffs your army's combat stats"
	var level = 0
	var skill_buffed = 'shields'
	var buff_factor = 6
	
	var cost_factor = 1.85
	var base_cost = {
		0:	0,
		1:	0,
		2:	0,
		3:	0}

	func cost_multiplier(L):
		return ceil(self.cost_factor * L + exp(L*0.33))

	func get_cost(L):
		var cost = {
			0:	self.base_cost[0] * cost_multiplier(L),
			1:	self.base_cost[1] * cost_multiplier(L),
			2:	self.base_cost[2] * cost_multiplier(L),
			3:	self.base_cost[3] * cost_multiplier(L)
				}
		return cost

	func can_build(cost):
		var go = true
		if cost[0] > int(self.bank.bank[0]['current']):
			go = false
		if cost[1] > int(self.bank.bank[1]['current']):
			go = false
		if cost[2] > int(self.bank.bank[2]['current']):
			go = false
		if cost[3] > int(self.bank.bank[3]['current']):
			go = false
		return go


	func upgrade():
		var cost = self.get_cost(self.level+1)
		if self.can_build(cost):
			
			#subtract costs
			self.bank.bank[0]['current'] -= cost[0]
			self.bank.bank[1]['current'] -= cost[1]
			self.bank.bank[2]['current'] -= cost[2]
			self.bank.bank[3]['current'] -= cost[3]
			
			self.level += 1
			self.combat.set_skills()

class BuffBuilding:
	var construction
	var bank
	var name = "Buff Building"
	var description = "This building increases the efficiency of resource gathering"
	var level = 0
	var skill_buffed = 0
	
	var base_cost = {
		0:	0,
		1:	0,
		2:	0,
		3:	0}
	var cost_factor = 1.75

	func cost_multiplier(L):
		return ceil(self.cost_factor * L + exp(L*0.33))

	func get_cost(L):
		var cost = {
			0:	self.base_cost[0] * cost_multiplier(L),
			1:	self.base_cost[1] * cost_multiplier(L),
			2:	self.base_cost[2] * cost_multiplier(L),
			3:	self.base_cost[3] * cost_multiplier(L)
				}
		return cost

	func can_build(cost):
		var go = true
		if cost[0] > int(self.bank.bank[0]['current']):
			go = false
		if cost[1] > int(self.bank.bank[1]['current']):
			go = false
		if cost[2] > int(self.bank.bank[2]['current']):
			go = false
		if cost[3] > int(self.bank.bank[3]['current']):
			go = false
		return go


	func upgrade():
		var cost = self.get_cost(self.level+1)
		if self.can_build(cost):
		
			#subtract costs
			self.bank.bank[0]['current'] -= cost[0]
			self.bank.bank[1]['current'] -= cost[1]
			self.bank.bank[2]['current'] -= cost[2]
			self.bank.bank[3]['current'] -= cost[3]
			
			self.level += 1
			self.bank.set_boost()

class StorageBuilding:
	var construction
	var bank
	var name = "Storage Building"
	var description = """This is a building which stores resources"""
	var level = 0
	var base_storage = {
			0:	0,
			1:	0,
			2:	0,
			3:	0}	#Tech has no storage limit, but placeholder needed for clean communication w/ bank
	
	func get_storage():
		var store = {
			0:	0,
			1:	0,
			2:	0,
			3:	0}
		for i in range(4):
			if self.base_storage[i] > 0:
				var amt = self.base_storage[i]
				for i in range(self.level):
					amt *= 2
				store[i] = amt
		return store
	
	func get_cost(L):	#HACK: L needed for clean communication. Not needed in this func
		var cost = self.get_storage()
		for c in cost:
			cost[c] /= 2
		return cost
	
	func can_build():
		var go = true
		var cost = self.get_cost(0)	#HACK: argument shouldn't be needed here
		for i in range(4):
			if cost[i] > int(self.bank.bank[i]['current']):
				go = false
		return go
	
	func upgrade():
		if self.can_build():
			var cost = self.get_cost(0)
			for i in range(4):
				self.bank.bank[i]['current'] -= cost[i]
			self.level += 1
			self.construction.set_storage()
		
	
class Building:
	var construction
	var bank
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
	
	func can_build(cost):
		var go = true
		if cost[0] > int(self.bank.bank[0]['current']):
			go = false
		if cost[1] > int(self.bank.bank[1]['current']):
			go = false
		if cost[2] > int(self.bank.bank[2]['current']):
			go = false
		if cost[3] > int(self.bank.bank[3]['current']):
			go = false
		return go


	func upgrade():
		var cost = self.get_cost(self.level+1)
		if self.can_build(cost):
		
			#subtract costs
			self.bank.bank[0]['current'] -= cost[0]
			self.bank.bank[1]['current'] -= cost[1]
			self.bank.bank[2]['current'] -= cost[2]
			self.bank.bank[3]['current'] -= cost[3]
			
			self.level += 1
			self.construction.set_population()
		
	func cost_multiplier(L):
		return ceil(self.cost_factor * L + exp(L*0.33))
		
	func get_cost(L):
		var cost = {
			0:	self.base_cost['metal'] * cost_multiplier(L),
			1:	self.base_cost['crystal'] * cost_multiplier(L),
			2:	self.base_cost['nanium'] * cost_multiplier(L),
			3:	self.base_cost['tech'] * cost_multiplier(L)
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

