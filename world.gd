extends Node

var building_class = preload('res://building_classes.gd')
var building_dialog = preload('res://upgrade_building_dialog.xml')

var Time = 0



class Colony:
	var name = "Colony"
	
	var max_slots = 32
	var used_slots = 0
	
	var center = null
	var buildings = []
	var facilities = []
	
	var my_metal= 10000
	var my_crystal = 5000
	var my_fuel = 0
	var my_energy = 0
	var energy_used = 0
	
	var metal_rate = 0
	var crystal_rate = 0
	var fuel_rate = 0

	func set_energy():
		my_energy = 0
		energy_used = 0
		my_energy += self.center.get('production','energy',self.center.level)
		energy_used += self.center.get('upkeep','energy',self.center.level)
		for i in self.buildings:
			my_energy += i.get('production','energy',i.level)
			energy_used += i.get('upkeep','energy',i.level)

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
		
		r.get_node('Energy/Amount').text = str(self.my_energy - self.energy_used)
		r.get_node('Energy/rate').text = str(self.my_energy)




var colony




func _ready():
	colony = Colony.new()
	var pcc = make_planetaryCommandCenter()
	colony.center = pcc
	
	var mine = make_metalMine()
	mine.is_upgrading = true
	mine.build_timer = mine.get_build_time(mine.level+1)
	colony.add_building(mine)
	
	var crystal = make_crystalMine()
	crystal.is_upgrading = true
	crystal.build_timer = crystal.get_build_time(crystal.level+1)
	colony.add_building(crystal)
	
	var fuel = make_fuelMine()
	fuel.is_upgrading = true
	fuel.build_timer = fuel.get_build_time(fuel.level+1)
	colony.add_building(fuel)
	
	var solar = make_solarFarm()
	solar.is_upgrading = true
	solar.build_timer = solar.get_build_time(solar.level+1)
	colony.add_building(solar)
	
	#get_node('Global/World/Tab/Buildings/Center').set_text(str('Lv',colony.center.level,' ',colony.center.name))
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
	
	if colony.center.is_upgrading:
		colony.center.build_timer -= delta
		get_node('./Global/World/Tab/Buildings/Center').set_text(str("Lv ",colony.center.level," ",colony.center.name," (Upgrading: ",get_node('/root/global').format_time(int(colony.center.build_timer)),")"))
		if colony.center.build_timer <= 0.0:
			colony.center.is_upgrading = false
			colony.center.level += 1
			colony.set_rates()
			colony.set_energy()
	else:
		get_node('./Global/World/Tab/Buildings/Center').set_text(str("Lv ",colony.center.level," ",colony.center.name))
	
	for building in colony.buildings:
		if building.is_upgrading:
			building.build_timer -= delta
			if building.build_timer <= 0.0:
				building.is_upgrading=false
				building.level += 1
				colony.set_rates()
				colony.set_energy()
			draw_buildings()







func draw_buildings():
	var buttons = get_node('/root/Game/Global/World/Tab/Buildings/cont/energy/cont/energy buildings')
	buttons.clear()
	for building in colony.buildings:
		var label = str("Lv",building.level," ",building.name)
		if building.is_upgrading:
			label += str(" (upgrading: ",get_node('/root/global').format_time(int(building.build_timer)))
		buttons.add_button(label)
	var add_building = buttons.add_button("ADD BUILDING")








func _on_energy_buildings_button_selected( button ):
	if colony.buildings.empty() or button == colony.buildings.size():
		
		#
		# Bring up Add Building dialog
		#
		print("ADD energy building")


	else:
		#
		# Bring up Building dialog
		#
		var window = building_dialog.instance()
		window.set_pos(Vector2(100,100))
		add_child(window)
		window.draw_window(colony,colony.buildings[button])


func _on_Center_pressed():
	var window = building_dialog.instance()
	window.set_pos(Vector2(100,100))
	window.draw_window(colony,colony.center)
	add_child(window)








func make_planetaryCommandCenter():
	var building = building_class.Building.new()
	
	building.name = "Planetary Command Center"
	
	
	building.level = 1
	
	building.build_time['base'] = 30
	building.build_time['rate'] = 10
	
	building.cost['metal']['base'] = 1000
	building.cost['metal']['rate'] = 1200
	
	building.cost['crystal']['base'] = 500
	building.cost['crystal']['rate'] = 750
	
	building.cost['fuel']['base'] = 10
	building.cost['fuel']['rate'] = 5
	
	building.production['metal']['base'] = 5
	building.production['metal']['rate'] = 18
	
	building.production['crystal']['base'] = 4
	building.production['crystal']['rate'] = 16
	
	building.production['fuel']['base'] = 2
	building.production['fuel']['rate'] = 14
	
	return building
	
func make_solarFarm():
	var building = building_class.Building.new()
	
	building.name = "Solar Farm"

	building.level = 0
	
	building.build_time['base'] = 10
	building.build_time['rate'] = 4
	
	building.cost['metal']['base'] = 50
	building.cost['metal']['rate'] = 50
	
	building.cost['crystal']['base'] = 25
	building.cost['crystal']['rate'] = 25
	
	building.production['energy']['base'] = 15
	building.production['energy']['rate'] = 10

	return building
	
func make_metalMine():
	var building = building_class.Building.new()
	
	building.name = "Metal Mine"

	building.level = 0
	
	building.build_time['base'] = 4
	building.build_time['rate'] = 3
	
	building.cost['metal']['base'] = 100
	building.cost['metal']['rate'] = 10
	
	building.cost['crystal']['base'] = 50
	building.cost['crystal']['rate'] = 18
	
	building.production['metal']['base'] = 25
	building.production['metal']['rate'] = 12
	
	building.upkeep['energy']['base'] = 2
	building.upkeep['energy']['rate'] = 3

	return building

func make_crystalMine():
	var building = building_class.Building.new()
	
	building.name = "Crystal Mine"

	building.level = 0
	
	building.build_time['base'] = 5
	building.build_time['rate'] = 2
	
	building.cost['metal']['base'] = 200
	building.cost['metal']['rate'] = 12
	
	building.cost['crystal']['base'] = 50
	building.cost['crystal']['rate'] = 16
	
	building.production['crystal']['base'] = 14
	building.production['crystal']['rate'] = 10
	
	building.upkeep['energy']['base'] = 3
	building.upkeep['energy']['rate'] = 2

	return building

func make_fuelMine():
	var building = building_class.Building.new()
	
	building.name = "Deuterium Still"

	building.level = 0
	
	building.build_time['base'] = 8
	building.build_time['rate'] = 4
	
	building.cost['metal']['base'] = 500
	building.cost['metal']['rate'] = 22
	
	building.cost['crystal']['base'] = 200
	building.cost['crystal']['rate'] = 24
	
	building.production['fuel']['base'] = 6
	building.production['fuel']['rate'] = 3
	
	building.upkeep['energy']['base'] = 4
	building.upkeep['energy']['rate'] = 5

	return building

