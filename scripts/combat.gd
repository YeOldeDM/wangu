
extends Control
var format

var battle_clock = 0.0
var turn_duration = 1.0

class Mob:
	var own
	var name = "Bob the Mob"
	
	var boss = 0
	
	var level = 0
	
	var strength = 1
	var vitality = 1
	
	var damage_factor = 1.6
	var damage_var = 0.4
	var health_factor = 4
	var health_var = 0.05
	
	var total_health = 0
	var current_health = 0
	
	var is_dead = true
	var random 
	
	func new_mob():
		if self.level > 0:
			self.own.map.next_cell()
		self.name = self.random.random_animal()
		self.level += 1
		if self.level % 100 == 0:	#Mega-Boss
			self.boss = 2
		elif self.level % 10 == 0:	#Mini-Boss
			self.boss = 1
		else:
			self.boss = 0
		self.get_total_health()
		self.current_health = self.total_health
		self.is_dead = false
		
		
		#HACKY level up system
		
		randomize()
		self.strength += int(rand_range(0,2))
		self.vitality += int(rand_range(0,4))
		
	func get_total_health():
		var base_health = (self.vitality*0.5) * self.health_factor
		if self.boss == 2:
			base_health *= 10.0
			prints("MEGABOSS",self.name,self.level)
		elif self.boss == 1:
			base_health *= 5.0
			prints("MINIBOSS",self.name,self.level)
		var min_health = ceil(base_health*self.health_var)
		var max_health = ceil(base_health*(1.0+self.health_var))
		randomize()
		self.total_health = round(rand_range(min_health,max_health)+exp(self.level*0.03))
	
	func damage():
		var base_damage = ((self.strength*0.5) * self.damage_factor) + exp(self.level*0.03)
		if self.level%10 == 0 and self.level > 0:
			base_damage *= 5
		elif self.level%100 == 0 and self.level > 0:
			base_damage *= 2
		var min_dmg = ceil(base_damage*self.damage_var)
		var max_dmg = ceil(base_damage*(1.0+self.damage_var))
		return [min_dmg,max_dmg]
		
	func attack():
		var dmg = self.damage()
		randomize()
		return round(rand_range(dmg[0],dmg[1]))
		
	func get_hit(dmg):
		var damage = max(0,dmg)
		var new_health = self.current_health - damage
		if new_health <= 0:
			self.current_health = 0
			self.die()
		else:
			self.current_health = new_health
	
	func die():
		self.is_dead = true
		



class Army:
	var troops = 1
	var damage = 3
	var damage_var = 0.4
	var unit_health = 10
	
	var skill = {
		'weapon':	0,
		'armor':	0,
		'shields':	0}
		
	
	var current_health = 0
	
	var is_dead = true
	
	var combat_ready = false
	var autofight = false
	
	var population
	var equipment
	
	func new_army():
		var pop = (self.population.population['current']*1.0) / (self.population.population['max']*1.0)
		if pop >= 0.9:
			self.population._change_current_population(-1*self.troops)
			self.population.refresh()
			self.current_health = self.total_health()
			self.is_dead = false
			self.combat_ready = true
			
	
	func damage():
		var base_damage = (self.damage+self.skill['weapon']) * self.troops
		var min_dmg = ceil(base_damage*damage_var)
		var max_dmg = ceil(base_damage * (1.0+damage_var))
		return [min_dmg,max_dmg]


	func attack():
		var dmg = self.damage()
		randomize()
		return round(rand_range(dmg[0],dmg[1]))
	
	func total_health():
		return (self.unit_health+self.skill['armor']) * self.troops

	func shields():
		return self.skill['shields'] * self.troops


	func get_hit(dmg):
		var damage = max(0,dmg-self.shields())
		var new_health = self.current_health - damage
		if new_health <= 0:
			self.current_health = 0
			self.die()
		else:
			self.current_health = new_health
	
	func die():
		self.is_dead = true
		if not self.autofight:
			self.combat_ready = false




var army
var mob

var bots_panel
var mob_panel

var map

class Map:
	var own
	var grid
	var sector = 0
	var zone = 1
	var cells
	var current_cell = 0

	func next_cell():
		self.cells[self.current_cell].status = 1
		self.current_cell += 1
		if self.current_cell > 99:
			self.next_zone()
		self.cells[self.current_cell].status = 2
		self.own.draw_map_info()
	
	func next_zone():
		self.zone += 1
		
		if self.zone > 10:
			self.zone = 1
			self.next_sector()
		else:
			self.own.news.message("[color=yellow]Welcome to Zone "+str(self.zone)+"[/color]")
		self.current_cell = 0
		var l = (self.sector*1000) + (self.zone*100)
		self.own.generate_map(l)
		for cell in self.cells:
			cell.status = 0
		self.cells[self.current_cell].status = 1
	
	func next_sector():
		self.sector += 1
		self.own.new.message("[color=yellow]Welcome to Sector "+str(self.sector)+self.sector+"[/color]")
		
var cell_button = preload('res://map_cell.xml')

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


func draw_map_info():
	get_node('Battle/map/sector').set_text(str("Sector ",format.greek_abc[map.sector]))
	get_node('Battle/map/zone').set_text(str("Zone ",str(map.zone)))
	for cell in map.cells:
		cell.change_color(cell.status)

func set_skills():
	army.skill = {
		'weapon':	0,
		'armor':	0,
		'shields':	0}
	for b in army.equipment:
		army.skill[b.building.skill_buffed] += (b.building.buff_factor * b.building.level)
	draw_bots_combat_info()

func draw_bots_combat_info():
	var troops = str("Troopers (",format._number(army.troops),")")
	var d = army.damage()
	var damage = str("Damage: ",format._number(d[0]),"-",format._number(d[1]))
	var shields = str("Shields: ",format._number(army.shields()))

	bots_panel.get_node('troops').set_text(troops)

	bots_panel.get_node('damage').set_text(damage)
	bots_panel.get_node('shields').set_text(shields)

func draw_mob_combat_info():
	var d = mob.damage()
	var level = str("Level ", mob.level)
	var damage = str("Damage: ", format._number(d[0]),"-",format._number(d[1]))

	mob_panel.get_node('mob').set_text(mob.name)
	mob_panel.get_node('mob_lvl').set_text(level)
	mob_panel.get_node('damage').set_text(damage)


func check_bots_healthbar(per):
	var bar = bots_panel.get_node('healthbar')
	var bar_per = bar.get_value()
	if per-0.05 < bar_per < per+0.05:
		bar.set_value(per)
	else:
		bar_per += (sign(per-bar_per) * (abs(per-bar_per)*0.05))*2
		bar.set_value(bar_per)
	var h = str(format._number(army.current_health),"/",format._number(army.total_health()))
	bar.get_node('health').set_text(h)

func check_mob_healthbar(per):
	var bar = mob_panel.get_node('healthbar')
	var bar_per = bar.get_value()
	if per-0.05 < bar_per < per+0.05:
		bar.set_value(per)
	else:
		bar_per += (sign(per-bar_per) * (abs(per-bar_per)*0.05))*2
		bar.set_value(bar_per)
	var h = str(format._number(mob.current_health),"/",format._number(mob.total_health))
	bar.get_node('health').set_text(h)

var news
func _ready():
	format = get_node('/root/formats')
	news = get_node('/root/Game/news')
	
	map = Map.new()
	map.own = self
	generate_map()
	
	army = Army.new()
	army.population = get_node('/root/Game/population')
	army.equipment = get_node('/root/Game/construction').equipments

	mob = Mob.new()
	mob.own = self
	mob.random = get_node('/root/random')
	mob.new_mob()
	
	
	bots_panel = get_node('Battle/cont/bots')
	mob_panel = get_node('Battle/cont/mobs')
	
	draw_bots_combat_info()
	draw_mob_combat_info()
	
	


var combat_ready = false

func process(delta):
	#UPDATE HEALTHBARS
	var b_per = (army.current_health*1.0) / (army.total_health()*1.0)
	check_bots_healthbar(b_per)

	var m_per = (mob.current_health*1.0) / (mob.total_health*1.0)
	check_mob_healthbar(m_per)

	battle_clock += delta
	if battle_clock >= turn_duration:
		battle_clock = 0.0
		if army.autofight:
			army.combat_ready = true
		if army.combat_ready:
			combat()

func combat():
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
			
			draw_mob_combat_info()




func _on_auto_fight_toggled( pressed ):
	if pressed:
		army.autofight = true
	else:
		army.autofight = false

func _on_fight_pressed():
	army.combat_ready = true
