extends Node

var building_class = preload('res://building_classes.gd')

var Time = 0



class Colony:
	var name = "Colony"
	
	var max_slots = 32
	var used_slots = 0
	
	var center = null
	var buildings = []
	var facilities = []
	
	var my_metal= 1000
	var my_crystal = 1000
	var my_fuel = 50
	var my_energy = 0
	
	var metal_rate = 0
	var crystal_rate = 0
	var fuel_rate = 0
	
	func set_energy():
		var e = 0
		e += self.center.get('production','energy',self.center.level)
		for i in self.buildings:
			e += i.get('production','energy',i.level)
		self.my_energy = e
		
	func set_slots():
		var slots = 0
		for i in self.buildings:
			slots += 1
		for i in self.facilities:
			slots += 1
		if slots <= self.max_slots:
			used_slots = slots
		else:
			print("TOO MANY SLOTS!!! HOW DID THAT HAPPEN?")
	
	func add_building(building):
		self.buildings.append(building)
		print(str("Added Building: ", building.name))
		
	func add_facility(facility):
		self.facilities.append(facility)
		print(str("Added Facility: ", facility.name))
	
	func set_rates():
		var m= self.center.get('production','metal',center.level)
		var c= self.center.get('production','crystal',center.level)
		var f= self.center.get('production','fuel',center.level)
		for building in self.buildings:
			m += building.get('production','metal',building.level)
			c += building.get('production','crystal',building.level)
			f += building.get('production','fuel',building.level)
		self.metal_rate = m
		self.crystal_rate = c
		self.fuel_rate = f
	
	func update_resources_ui(r):
		r.get_node('Metal/Amount').text = str(int(self.my_metal))
		r.get_node('Metal/rate').text = str('+',self.metal_rate,'/m')
		
		r.get_node('Crystal/Amount').text = str(int(self.my_crystal))
		r.get_node('Crystal/rate').text = str('+',self.crystal_rate,'/m')
		
		r.get_node('Fuel/Amount').text = str(int(self.my_fuel))
		r.get_node('Fuel/rate').text = str('+',self.fuel_rate,'/m')
		
		r.get_node('Energy/Amount').text = str(self.my_energy)




var colony




func _ready():
	colony = Colony.new()
	var pcc = make_planetaryCommandCenter()
	colony.center = pcc
	

	get_node('Global/World/Tab/Buildings/Center').set_text(str('Lv',colony.center.level,' ',colony.center.name))
	colony.set_energy()
	colony.set_rates()

	draw_buildings()
	
	
	set_process(true)







func _process(delta):
	colony.my_metal += (delta * colony.metal_rate)/60
	colony.my_crystal += (delta * colony.crystal_rate)/60
	colony.my_fuel += (delta * colony.fuel_rate)/60
	colony.update_resources_ui(get_node('Global/World/Resources'))
	
	Time += delta
	get_node('Timer').set_text(str("Time: ",get_node('/root/global').format_time(int(Time))))
	








func draw_buildings():
	var buttons = get_node('/root/Game/Global/World/Tab/Buildings/cont/energy/cont/energy buildings')
	for building in colony.buildings:
		buttons.add_button(str("Lv",building.level," ",building.name))
	var add_building = buttons.add_button("ADD BUILDING")








func _on_energy_buildings_button_selected( button ):
	if colony.buildings.empty() or button > colony.buildings.size():
		
		#
		# Bring up Add Building dialog
		#
		print("ADD energy building")
		
	else:
		#
		# Bring up Building dialog
		#
		print(colony.buildings[button].name)









func make_planetaryCommandCenter():
	var pcc = building_class.Building.new()
	
	pcc.name = "Planetary Command Center"
	pcc.level = 1
	
	pcc.build_time['base'] = 30
	pcc.build_time['rate'] = 64
	
	pcc.cost['metal']['base'] = 100
	pcc.cost['metal']['rate'] = 120
	
	pcc.cost['crystal']['base'] = 100
	pcc.cost['crystal']['rate'] = 114
	
	pcc.production['metal']['base'] = 5
	pcc.production['metal']['rate'] = 8
	
	pcc.production['crystal']['base'] = 4
	pcc.production['crystal']['rate'] = 6
	
	
	return pcc
	


