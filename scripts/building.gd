
extends TextureButton

var building

var bank
var population
var combat
var news
var format


class Structure:
	var own
	var structID = "no_structure"
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
		return ceil((self.cost_factor * L) + ((L ^ 2)*0.33))
		
	func _get_cost(L):
		var cost = {0:0,1:0,2:0,3:0}
		#Storage Structures have special cost progression
		if self.category == "Storage":
			var c = self.own.bank.bank[self.material]['max'] / 2
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
		if not self.own.bank.can_afford(0,cost[0]):
			can_afford = false
		elif not self.own.bank.can_afford(1,cost[1]):
			can_afford = false
		elif not self.own.bank.can_afford(2,cost[2]):
			can_afford = false
		elif not self.own.bank.can_afford(3,cost[3]):
			can_afford = false
		return can_afford
	
	func _spend(cost):
#		for i in range(4):
#			self.own.bank.spend_resource(i,int(cost[i]))
		self.own.bank.spend_resource(0,cost[0])
		self.own.bank.spend_resource(1,cost[1])
		self.own.bank.spend_resource(2,cost[2])
		self.own.bank.spend_resource(3,cost[3])
	
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

func _init():
	building = Structure.new()
	building.own = self




func _ready():
	format = get_node('/root/formats')
	bank = get_node('/root/Game/Bank')
	combat = get_node('/root/Game/combat')
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
	var cost = building._get_cost(l+1)
	if building._can_build(cost):
		building.upgrade(1)
		draw_button()
		if l != building.level:
			news.message("The [color=#66ffff]"+building.name+"[/color] has been upgraded to [b]level "+str(building.level)+"[/b]")




var cost_color = [Color(1.0,1.0,1.0,1.0),
					Color(1.0,0.2,0.2,1.0)]

func _on_Popup_about_to_show():
	var panel = get_node('Popup')
	
	panel.get_node('name').set_text(building.name)
	panel.get_node('level').set_text(str("Level ",format._number(building.level)))
	panel.get_node('description').clear()
	panel.get_node('description').add_text(building.description)
	
	var cost = building._get_cost(building.level+1)
	
#Set Metal Cost Text
	var c = 0
	if not bank.can_afford(0,cost[0]):
		c = 1
	panel.get_node('metal_cost').set('custom_colors/font_color', cost_color[c])
	if cost[0] <= 0.0:
		panel.get_node('metal_cost').set_text("")
	else:
		panel.get_node('metal_cost').set_text(format._number(cost[0]))
#Set Crystal Cost Text
	c = 0
	if not bank.can_afford(1,cost[1]):
		c = 1
	panel.get_node('crystal_cost').set('custom_colors/font_color', cost_color[c])
	if cost[1] <= 0.0:
		panel.get_node('crystal_cost').set_text("")
	else:
		panel.get_node('crystal_cost').set_text(format._number(cost[1]))
#Set Nanium Cost Text
	c = 0
	if not bank.can_afford(2,cost[2]):
		c = 1
	panel.get_node('nanium_cost').set('custom_colors/font_color', cost_color[c])
	if cost[2] <= 0.0:
		panel.get_node('nanium_cost').set_text("")
	else:
		panel.get_node('nanium_cost').set_text(format._number(cost[2]))
#Set Tech Cost Text
	c = 0
	if not bank.can_afford(3,cost[3]):
		c = 1
	panel.get_node('tech_cost').set('custom_colors/font_color', cost_color[c])
	if cost[3] <= 0.0:
		panel.get_node('tech_cost').set_text("")
	else:
		panel.get_node('tech_cost').set_text(format._number(cost[3]))

	#get position for popup (lower right corner of parent)
	var pos = get_global_pos() + get_size()
	var res = get_node('/root').get_rect()
	
	#clamp popup to screen edges
	pos.x = clamp(pos.x, 0, res.size.width - panel.get_size().x)
	pos.y = clamp(pos.y, 0, res.size.height - panel.get_size().y)
	#set that pos!
	panel.set_pos(pos)