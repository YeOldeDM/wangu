
extends Control


#################
#	MOB CLASS	#
#################
class Mob:
	var own		#link to combat object
	var rng		#link to random name generator
	var name = "Bob the Mob"
	var boss = 0	#0=normal mob, 1=mini-boss, 2=mega-boss
	
	#MOB STATS
	var level = 0
		#DMG
	var strength = 1
	var damage_factor = 1.6
	var damage_var = 0.4
		#HP
	var vitality = 1
	var health_factor = 4
	var health_var = 0.05
	
	var total_health = 0
	var current_health = 0
	
	var is_dead = true

	#PRIVATE FUNCTIONS
	func _get_total_health():
		var base_health = max(1,(self.vitality*0.5)) * self.health_factor		#base= 1/2VIT x HPfactor
		if self.boss == 2:												#mega-bosses: x10
			base_health *= 10.0
			prints("MEGABOSS",self.name,", LVL",self.level)
		elif self.boss == 1:											#mini-bosses: x5
			base_health *= 5.0
			prints("MINIBOSS",self.name,", LVL",self.level)

		var min_health = ceil(base_health*self.health_var)				#min-max variation
		var max_health = ceil(base_health*(1.0+self.health_var))
		randomize()
		#Roll for total HP and set
		self.total_health = round(rand_range(min_health,max_health) + exp(self.level*0.03))
	
	func _damage():
		var base_damage = ((self.strength*0.5) * self.damage_factor) + exp(self.level*0.03)

		if self.level%10 == 0 and self.level > 0:
			base_damage *= 5
		elif self.level%100 == 0 and self.level > 0:
			base_damage *= 2
		var min_dmg = ceil(base_damage*self.damage_var)
		var max_dmg = ceil(base_damage*(1.0+self.damage_var))
		return [min_dmg,max_dmg]
	
	func _die():
		self.is_dead = true


	#PUBLIC FUNCTIONS
	func new_mob():		#The old Mob is dead...long live the New Mob
		if self.level > 0:
			self.own.collect_loot(self)	#collect any loot from previous mob
		
		self.name = self.rng.random_animal()	#new name
		self.level += 1							#new level
		#get boss status
		if self.level % 100 == 0:	#Mega-Boss
			self.boss = 2
		elif self.level % 10 == 0:	#Mini-Boss
			self.boss = 1
		else:
			self.boss = 0
		self._get_total_health()						#recalculate total HP
		self.current_health = self.total_health		#refill HP
		self.is_dead = false						#I...live...again!
		
		
		#HACKY level up system
		randomize()
		self.strength += int(rand_range(0,2))
		self.vitality += int(rand_range(0,4))
	
	func attack():
		var dmg = _damage()
		randomize()
		return round(rand_range(dmg[0],dmg[1]))
	
	func get_hit(dmg):
		var damage = max(0,dmg)
		var new_health = self.current_health - damage
		if new_health <= 0:
			self.current_health = 0
			self._die()
		else:
			self.current_health = new_health
#####################
#	/END MOB CLASS	#
#####################




#################
#	ARMY CLASS	#
#################
class Army:
	var population			#link to Population module
	var equipment			#link to Construction -> equipments
	
	#	ARMY STATS	#
	var troops = 1			#no of Troopers in your army
	var damage = 3			#base damage per Trooper
	var damage_var = 0.4	#damage variation
	var unit_health = 10	#base HP per Trooper
	
	#modifiers from Equipment
	var skill = {
		0:	0,		#weapons
		1:	0,		#armor
		2:	0}		#shields
	
	var current_health = 0
	var total_health = 0
	
	var is_dead = true
	var combat_ready = false	#are we okay to go into battle?
	var autofight = false		#Auto-Fight switch
	
	#	PRIVATE FUNCTIONS	#
	func _damage():
		var base_damage = (self.damage+self.skill[0]) * self.troops
		var min_dmg = ceil(base_damage*damage_var)
		var max_dmg = ceil(base_damage * (1.0+damage_var))
		return [min_dmg,max_dmg]
	
	func _die():
		self.is_dead = true
		if not self.autofight:
			self.combat_ready = false
	
	func _get_total_health():
		self.total_health = (self.unit_health+self.skill[1]) * self.troops

	func _get_shields():
		return self.skill[2] * self.troops
	
	#	PUBLIC FUNCTIONS	#
	func new_army():
		var pop = (self.population.population['current']*1.0) / (self.population.population['max']*1.0)
		if pop >= 0.9:
			self.population._change_current_population(-1*self.troops)
			self.population._refresh()
			self._get_total_health()
			self.current_health = self.total_health
			self.is_dead = false
			self.combat_ready = true
	
	func attack():
		var dmg = self._damage()
		randomize()
		return round(rand_range(dmg[0],dmg[1]))
	
	func get_hit(dmg):
		var damage = max(0,dmg-self._get_shields())
		var new_health = self.current_health - damage
		if new_health <= 0:
			self.current_health = 0
			self._die()
		else:
			self.current_health = new_health
#####################
#	/END ARMY CLASS	#
#####################


#################
#	MAP CLASS	#
#################
class Map:
	var own		#link to combat object
	var grid	#link to map grid
	
	#	MAP STATS	#
	var sector = 0
	var zone = 1
	var cells
	var current_cell = 0

	#	PRIVATE FUNCTIONS	#
	func _next_zone():
		self.zone += 1
		
		if self.zone > 10:
			self.zone = 1
			self._next_sector()
		else:
			self.own.news.message("[color=yellow]Welcome to Zone "+str(self.zone)+"[/color]")
		self.current_cell = 0
		var l = (self.sector*1000) + (self.zone*100)
		self.own.regenerate_map(l)
		for cell in self.cells:
			cell.status = 0
		self.cells[self.current_cell].status = 1
		
	func _next_sector():
		self.sector += 1
		self.own.new.message("[color=yellow]Welcome to Sector "+str(self.sector)+self.sector+"[/color]")

	#	PUBLIC FUNCTIONS	#
	func next_cell():
		self.cells[self.current_cell].status = 1
		self.current_cell += 1
		if self.current_cell > 99:
			self._next_zone()
		self.cells[self.current_cell].status = 2
		if self.cells[self.current_cell].loot_type <= 4:
			self.own.current_loot_type = self.cells[self.current_cell].loot_type
			self.own.current_loot_amt = self.cells[self.current_cell].loot_amt
		else:
			self.own.current_loot_type = 5
		self.own.draw_map_info()
#####################
#	/END MAP CLASS	#
#####################

#External Links
var format
var bank
var population
var news
var construction

var battle_clock = 0.0
var turn_duration = 1.0

#Internal Links
var army
var mob
var map

#GUI Links
var bots_panel
var mob_panel

var current_loot_type = 10
var current_loot_amt = 0

#Object Links
var cell_button = preload('res://map_cell.xml')

#Combat Ready switch(need?)
var combat_ready = false

func save():
	var saveDict = {
		'sector':	map.sector,
		'zone':		map.zone,
		'cell':		map.current_cell,
		'mob':		{
					'name':		mob.name,
					'level':	mob.level,
					'boss':		mob.boss,
					'strength':	mob.strength,
					'vitality':	mob.vitality,
					'current_health':	mob.current_health,
					'total_health':		mob.total_health
			}
	}
	return saveDict

func restore(source):
	prints("Restoring Combat:", source.keys() )
	
	#RESTORE MAP
	map.sector = int(source['sector'])
	map.zone = int(source['zone'])
	map.current_cell = int(source['cell'])
	draw_map_info()
	
	#RESTORE MOB
	var smob = source['mob']
	mob.name = smob['name']
	mob.level = int(smob['level'])
	mob.boss = int(smob['boss'])
	mob.strength = int(smob['strength'])
	mob.vitality = int(smob['vitality'])
	mob.current_health = int(smob['current_health'])
	mob.total_health = int(smob['total_health'])
	draw_mob_combat_info()
	
	#RESTORE ARMY
	set_troopers()
	for i in range(3):
		set_equipment(i)
	draw_bots_combat_info()
	
#################
#	MAINLOOP	#
#################
func process(delta):
	#UPDATE HEALTHBARS
	var b_per = (army.current_health*1.0) / (army.total_health*1.0)
	_check_bots_healthbar(b_per)

	var m_per = (mob.current_health*1.0) / (mob.total_health*1.0)
	_check_mob_healthbar(m_per)
	
	#run battle engine
	battle_clock += delta
	if battle_clock >= turn_duration:
		battle_clock = 0.0
		if army.autofight:
			army.combat_ready = true
		if army.combat_ready:
			_combat()

#########################
#	PUBLIC FUNCTIONS	#
#########################


func generate_map(level=0):
	var grid_panel = get_node('Battle/map/grid')
	for cell in grid_panel.get_children():
		cell.queue_free()
	for i in range(100):
		var cell = cell_button.instance()
		cell.make_loot(level+i)
		grid_panel.add_child(cell)
	map.cells = grid_panel.get_children()
	map.cells[map.current_cell].status = 2
	map.cells[map.current_cell].change_color(2)

func regenerate_map(level=0):
	var cells = get_node('Battle/map/grid').get_children()
	for cell in cells:
		cell.status = 0
		cell.loot_type = 5
		if level > 0:
			cell.make_loot(level+1)
	cells[0].status = 2
	for cell in cells:
		cell.change_color(cell.status)

func draw_map_info():
	get_node('Battle/map/sector').set_text(str("Sector ",format.greek_abc[map.sector]))
	get_node('Battle/map/zone').set_text(str("Zone ",str(map.zone)))
	for cell in map.cells:
		cell.change_color(cell.status)

func set_equipment(equip):
	var value = 0
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == 'Equipment':
				if struct.building.material == equip:
					value += (struct.building.factor * struct.building.level)
	army.skill[int(equip)] = value
	draw_bots_combat_info()

func set_troopers():
	var value = 0
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == "Tactics":
				value += struct.building.level
	var troops = 1
	for i in range(value):
		troops += ceil(troops * 0.25)
	army.troops = troops
	draw_bots_combat_info()


func draw_bots_combat_info():
	var troops = str("Troopers (",format._number(army.troops),")")
	var d = army._damage()
	var damage = str("Damage: ",format._number(d[0]),"-",format._number(d[1]))
	var shields = str("Shields: ",format._number(army._get_shields()))

	bots_panel.get_node('troops').set_text(troops)

	bots_panel.get_node('damage').set_text(damage)
	bots_panel.get_node('shields').set_text(shields)

func draw_mob_combat_info():
	var d = mob._damage()
	var level = str("Level ", mob.level)
	var damage = str("Damage: ", format._number(d[0]),"-",format._number(d[1]))

	mob_panel.get_node('mob').set_text(mob.name)
	mob_panel.get_node('mob_lvl').set_text(level)
	mob_panel.get_node('damage').set_text(damage)

func collect_loot(mob):
	if current_loot_type == 4:
		population.land += 3
		population.set_max_population()
		var txt = "You've cleared out some good land to house your Bots. Population increased by [b]3[/b]!"
		news.message(txt)
	elif current_loot_type < 4:
		var loot = int(current_loot_type)
		var amt = int(current_loot_amt)
		bank.gain_resource(loot,amt)
		var mats = {0: "metal",
					1: "crystal",
					2: "nanium",
					3: "tech"}
		var txt = "The "+mob.name+" gives up [color=#999966][b]"+str(amt)+" "+mats[loot]+"![/b][/color]"
		news.message(txt)



#########################
#	PRIVATE FUNCTIONS	#
#########################
func _combat():
	#COMBAT ENGINE
	if not army.is_dead and not mob.is_dead:
		if not army.is_dead:
			var army_dmg = army.attack()
			mob.get_hit(army_dmg)
			if not mob.is_dead:
				var mob_dmg = mob.attack()
				army.get_hit(mob_dmg)

	else:
		if army.is_dead:
			if army.combat_ready:
				army.new_army()
		if mob.is_dead:
			if mob.boss > 0:
				news.message("[color=red]The [b]"+mob.name+"[/b] falls heavy at your feet.[/color]")
			mob.new_mob()
			map.next_cell()
			
			draw_mob_combat_info()


func _check_bots_healthbar(per):
	var bar = bots_panel.get_node('healthbar')
	var bar_per = bar.get_value()
	if per-0.05 < bar_per < per+0.05:
		bar.set_value(per)
	else:
		bar_per += (sign(per-bar_per) * (abs(per-bar_per)*0.05))*2
		bar.set_value(bar_per)
	var h = str(format._number(army.current_health),"/",format._number(army.total_health))
	bar.get_node('health').set_text(h)

func _check_mob_healthbar(per):
	var bar = mob_panel.get_node('healthbar')
	var bar_per = bar.get_value()
	if per-0.05 < bar_per < per+0.05:
		bar.set_value(per)
	else:
		bar_per += (sign(per-bar_per) * (abs(per-bar_per)*0.05))*2
		bar.set_value(bar_per)
	var h = str(format._number(mob.current_health),"/",format._number(mob.total_health))
	bar.get_node('health').set_text(h)



#############
#	INIT	#
#############
func _ready():
	format = get_node('/root/formats')
	news = get_node('/root/Game/news')
	bank = get_node('/root/Game/Bank')
	population = get_node('/root/Game/population')
	construction = get_node('/root/Game/construction')
	
	map = Map.new()
	map.own = self
	generate_map()
	
	army = Army.new()
	army.population = get_node('/root/Game/population')

	mob = Mob.new()
	mob.own = self
	mob.rng = get_node('/root/random')
	mob.new_mob()
	
	
	bots_panel = get_node('Battle/cont/bots')
	mob_panel = get_node('Battle/cont/mobs')
	
	draw_bots_combat_info()
	draw_mob_combat_info()
	




#####################
#	CHILD SIGNALS	#
#####################
func _on_auto_fight_toggled( pressed ):
	if pressed:
		army.autofight = true
	else:
		army.autofight = false

func _on_fight_pressed():
	army.combat_ready = true
