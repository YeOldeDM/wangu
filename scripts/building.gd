
extends TextureButton

#SHINY NEW GENERIC STRUCTURE CLASS
class Structure:
	var own
	var name = "Structure"
	var description = "This is a building, science project, or equipment"
	var category = ""	#"Housing", "Storage", "Boost", "Equipment", "Tactics"
	var level = 0
	
	var material = 0
	var factor = 0
	
	
	var cost_factor = 1.75
	var base_cost = {
		0:0, 1:0, 2:0, 3:0}
	
	func _cost_multiplier(L):
		return ceil(self.cost_factor * L + exp(L*0.33))
		
	func _get_cost(L):
		var cost = {0:0,1:0,2:0,3:0}
		#Storage Structures have special cost progression
		if self.category == "Storage":
			var c = 50
			for i in range(L-1):
				c *= 2
			cost[self.material] = c
		#All other Structures use normal cost progression
		else:
			var c = self.base_cost
			var m = self._cost_multiplier(L)
			cost = {
				0:	c[0] * m,
				1:	c[1] * m,
				2:	c[2] * m,
				3:	c[3] * m
					}
		return cost
	
	func _can_build(cost):
		#check if we can afford cost
		var can_afford = true
		
		return can_afford
	
	func _spend(cost):
		for i in range(4):
			self.bank.spend_resource(i,int(cost[i]))
	
	func _apply_effects():
		if self.category == 'Housing':
			self.own.population.set_max_population()
		
		elif self.category == 'Storage':
			self.own.bank.set_storage(self.material)
		
		elif self.category == 'Boost':
			self.own.bank.set_boost(self.material)
		
		elif self.category == 'Equipment':
			self.own.combat.set_equipment(self.material)
		
		elif self.category == 'Tactics':
			self.own.combat.set_troopers()
		
	func upgrade(n):
		#Try upgrading this structure by n levels
		n += self.level
		var cost = _get_cost(n)
		if _can_build(cost):
			_spend(cost)
			self.level += 1
			_apply_effects()



var building

var bank
var population
var news
var format

func _ready():
	format = get_node('/root/formats')
	bank = get_node('/root/Game/Bank')
	population = get_node('/root/Game/population')
	news = get_node('/root/Game/news')
	


func draw_button():
	if building:
		get_node('name').set_text(building.name)
		get_node('level').set_text(format._number(building.level))




func _on_Button_mouse_enter():
	get_node('Popup').popup()


func _on_Button_mouse_exit():
	get_node('Popup').hide()


func _on_Button_pressed():
	var l = building.level
	building.upgrade(building.level+1)
	draw_button()
	if l != building.level:
		news.message("The [color=#66ffff]"+building.name+"[/color] has been upgraded to [b]level "+str(building.level)+"[/b]")




var cost_color = [Color(0.4,0.4,0.4,0.4),
					Color(1.0,0.4,0.4,0.4)]

func _on_Popup_about_to_show():
	var panel = get_node('Popup')
	
	panel.get_node('name').set_text(building.name)
	panel.get_node('level').set_text(str("Level ",format._number(building.level)))
	panel.get_node('description').clear()
	panel.get_node('description').add_text(building.description)
	
	var cost = building.get_cost(building.level+1)
	var c = 0
	if not bank.can_afford(0,cost[0]):
		c = 1
	panel.get_node('metal_cost').set('custom_colors/font_color_shadow', cost_color[c])
	panel.get_node('metal_cost').set_text(format._number(cost[0]))
	c = 0
	if not bank.can_afford(1,cost[1]):
		c = 1
	panel.get_node('crystal_cost').set('custom_colors/font_color_shadow', cost_color[c])
	panel.get_node('crystal_cost').set_text(format._number(cost[1]))
	c = 0
	if not bank.can_afford(2,cost[2]):
		c = 1
	panel.get_node('nanium_cost').set('custom_colors/font_color_shadow', cost_color[c])
	panel.get_node('nanium_cost').set_text(format._number(cost[2]))
	c = 0
	if not bank.can_afford(3,cost[3]):
		c = 1
	panel.get_node('tech_cost').set('custom_colors/font_color_shadow', cost_color[c])
	panel.get_node('tech_cost').set_text(format._number(cost[3]))
