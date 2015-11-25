
extends Control
var format

var battle_clock = 0.0
var turn_duration = 1.0

class Mob:
	var name = "Bob the Mob"
	
	var level = 1
	
	var strength = 1
	var vitality = 1
	
	var damage_factor = 1.6
	var damage_var = 0.4
	var health_factor = 12
	var health_var = 0.05
	
	var total_health = 0
	var current_health = 0
	
	var is_dead = true
	
	func new_mob():
		self.get_total_health()
		self.current_health = self.total_health
		self.is_dead = false
	
	func get_total_health():
		var base_health = self.vitality * self.health_factor
		var min_health = ceil(base_health*self.health_var)
		var max_health = ceil(base_health*(1.0+self.health_var))
		self.total_health = round(rand_range(min_health,max_health)+exp(self.level*0.1))
	
	func damage():
		var base_damage = (self.strength * self.damage_factor) + exp(self.level*0.1)
		var min_dmg = ceil(base_damage*self.damage_var)
		var max_dmg = ceil(base_damage*(1.0+self.damage_var))
		return [min_dmg,max_dmg]
		
	func attack():
		var dmg = self.damage()
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
	
	var weapons = 0
	var armor = 0
	var shields = 0
	
	var current_health = 0
	
	var is_dead = true
	
	var combat_ready = false
	var autofight = false
	
	var population
	
	func new_army():
		var pop = int(self.population.population['current'])
		print(pop)
		if pop > self.troops:
			self.population._change_current_population(-1*self.troops)
			self.population.refresh()
			self.current_health = self.total_health()
			self.is_dead = false
			self.combat_ready = true
			
	
	func damage():
		var base_damage = (self.damage+self.weapons) * self.troops
		var min_dmg = ceil(base_damage*damage_var)
		var max_dmg = ceil(base_damage * (1.0+damage_var))
		return [min_dmg,max_dmg]
		
		
	func attack():
		var dmg = self.damage()
		return round(rand_range(dmg[0],dmg[1]))
	
	func total_health():
		return (self.unit_health+self.armor) * self.troops

	func shields():
		return self.shields * self.troops
	
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

var sector = 6
var zone = 1

func draw_map_info():
	get_node('Battle/map/sector').set_text(str("Sector ",format.greek_abc[sector]))
	get_node('Battle/map/zone').set_text(str("Zone ",str(zone)))



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


func _ready():
	format = get_node('/root/formats')
	
	army = Army.new()
	army.population = get_node('/root/Game/population')
	
	mob = Mob.new()
	
	
	bots_panel = get_node('Battle/cont/bots')
	mob_panel = get_node('Battle/cont/mobs')
	
	draw_bots_combat_info()
	draw_mob_combat_info()
	
	
	#set_process(true)

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
			mob.new_mob()




func _on_auto_fight_toggled( pressed ):
	if pressed:
		army.autofight = true
	else:
		army.autofight = false


func _on_fight_pressed():
	army.combat_ready = true
