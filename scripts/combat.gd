
extends Control
var format

class Mob:
	var name = "Bob the Mob"
	
	var level = 1
	var damage = 1
	var damage_var = 0.4
	var health = 25
	var current_health = health
	
	func mob_damage():
		var min_dmg = ceil(damage*damage_var)
		var max_dmg = ceil(damage*(1.0+damage_var))
		return [min_dmg,max_dmg]
		
	func mob_attack():
		var dmg = self.mob_damage()
		return round(rand_range(dmg[0],dmg[1]))
		
	func mob_get_hit(dmg):
		var damage = max(0,dmg-self.army_defense())
		var new_health = self.current_health - damage
		if new_health <= 0:
			self.die()
		else:
			self.current_health = new_health
	
	func die():
		pass	#mob death function

class Army:
	var troops = 1
	var damage = 3
	var damage_var = 0.4
	var unit_health = 10
	
	var weapons = 0
	var armor = 0
	var shields = 0
	
	var current_health = 0
	
	func new_army():
		self.current_health = self.army_health()
	
	func army_damage():
		var base_damage = (self.damage+self.weapons) * self.troops
		var min_dmg = ceil(base_damage*damage_var)
		var max_dmg = ceil(base_damage * (1.0+damage_var))
		return [min_dmg,max_dmg]
		
		
	func army_attack():
		var dmg = self.army_damage()
		return round(rand_range(dmg[0],dmg[1]))
	
	func army_health():
		return (self.unit_health+self.armor) * self.troops

	func army_shields():
		return self.shields * self.troops
	
	func army_get_hit(dmg):
		var damage = max(0,dmg-self.army_defense())
		var new_health = self.current_health - damage
		if new_health <= 0:
			self.die()
		else:
			self.current_health = new_health
	
	func die():
		self.new_army()



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
	var d = army.army_damage()
	var damage = str("Damage: ",format._number(d[0]),"-",format._number(d[1]))
	var shields = str("Shields: ",format._number(army.army_shields()))
	
	bots_panel.get_node('troops').set_text(troops)
	bots_panel.get_node('damage').set_text(damage)
	bots_panel.get_node('shields').set_text(shields)

func draw_mob_combat_info():
	var d = mob.mob_damage()
	var level = str("Level ", mob.level)
	var damage = str("Damage: ", format._number(d[0]),"-",format._number(d[1]))

	mob_panel.get_node('mob').set_text(mob.name)
	mob_panel.get_node('mob_lvl').set_text(level)
	mob_panel.get_node('damage').set_text(damage)


func check_bots_healthbar(per):
	var bar = bots_panel.get_node('healthbar')
	var bar_per = bar.get_value()
	if per-0.1 < bar_per < per+0.1:
		bar.set_value(per)
	else:
		bar_per += sign(per-bar_per) * (abs(per-bar_per)*0.05)
		bar.set_value(bar_per)
	var h = str(format._number(army.current_health),"/",format._number(army.army_health()))
	bar.get_node('health').set_text(h)

func check_mob_healthbar(per):
	var bar = mob_panel.get_node('healthbar')
	var bar_per = bar.get_value()
	if per-0.1 < bar_per < per+0.1:
		bar.set_value(per)
	else:
		bar_per += sign(per-bar_per) * (abs(per-bar_per)*0.05)
		bar.set_value(bar_per)
	var h = str(format._number(mob.current_health),"/",format._number(mob.health))
	bar.get_node('health').set_text(h)



func _ready():
	format = get_node('/root/formats')
	
	army = Army.new()
	mob = Mob.new()
	
	army.new_army()
	bots_panel = get_node('Battle/cont/bots')
	mob_panel = get_node('Battle/cont/mobs')
	
	draw_bots_combat_info()
	draw_mob_combat_info()
	
	
	set_process(true)





func _process(delta):
	var b_per = (army.current_health*1.0) / (army.army_health()*1.0)
	check_bots_healthbar(b_per)
	
	var m_per = (mob.current_health*1.0) / (mob.health*1.0)
	check_mob_healthbar(m_per)


