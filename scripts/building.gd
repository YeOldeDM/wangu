
extends TextureButton

#SHINY NEW GENERIC STRUCTURE CLASS
class Structure:
	var name = "Structure"
	var description = "This is a building, science project, or equipment"
	var category = ""	#"Housing", "Storage", "Buff", "Equipment", "Tactics"
	var level = 0
	
	var cost_factor = 1.75
	var base_cost = {
		0:0, 1:0, 2:0, 3:0}
	
	func _cost_multiplier(L):
		return ceil(self.cost_factor * L + exp(L*0.33))
		
	func _get_cost(L):
		var cost
		if self.category == "Storage":
			cost = 0
		else:
			var m = self._cost_multiplier(L)
			cost = {
				0:	self.base_cost[0] * m,
				1:	self.base_cost[1] * m,
				2:	self.base_cost[2] * m,
				3:	self.base_cost[3] * m
					}
		return cost
	
	func _can_build(cost):
		#check if we can afford cost
		var can_afford = true
		
		return can_afford
	
	func _apply_effects():
		#apply the effects of this building
		pass
	
	func upgrade(n):
		#Try upgrading this structure by n levels
		n += self.level
		var cost = _get_cost(n)
		if _can_build(cost):
			self.level += 1
			_apply_effects()
		
	

#SHITTY OLD NOODLY BUILDING CLASSES
class TacticsBuilding:
	var construction
	var bank
	var combat
	var name = "Tactics Building"
	var description = ""
	var level = 0
	
	var cost_factor = 1.75
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
			self.combat.army.troops = ceil(self.combat.army.troops * 1.25)
			self.combat.draw_bots_combat_info()




class EquipmentBuilding:
	var construction
	var bank
	var combat
	var name = "Equipment"
	var description = "This is equipment. It buffs your army's combat stats"
	var level = 0
	var skill_buffed = 'shields'
	var buff_factor = 6
	
	var cost_factor = 1.55
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
var news
func _ready():
	news = get_node('/root/Game/news')

func draw_button():
	if building:
		get_node('name').set_text(building.name)
		get_node('level').set_text(str("Level ",str(building.level)))



func _on_Button_mouse_enter():
	get_node('Popup').popup()


func _on_Button_mouse_exit():
	get_node('Popup').hide()


func _on_Button_pressed():
	var l = building.level
	building.upgrade()
	draw_button()
	if l != building.level:
		news.message("The [color=#66ffff]"+building.name+"[/color] has been upgraded to [b]level "+str(building.level)+"[/b]")

