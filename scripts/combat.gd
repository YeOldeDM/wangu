
extends Control
var format

class Army:
	var troops = 32
	var damage = 1
	var damage_var = 0.4
	var unit_health = 5
	
	var weapons = 12
	var armor = 34
	var shields = 0
	
	var current_health = 0
	
	func new_army():
		self.current_health = self.army_health()/2
	
	func army_damage():
		var base_damage = (self.damage+self.weapons) * self.troops
		var min_dmg = ceil(base_damage*damage_var)
		var max_dmg = ceil(base_damage * (1.0+damage_var))
		return [min_dmg,max_dmg]
		
		
	func army_attack():
		var dmg = self.army_damage()
		return randi(dmg[0],dmg[1])
	
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
var bots_panel
var mob_panel

var sector = 0
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



func check_bots_healthbar(per):
	var bar = bots_panel.get_node('healthbar')
	var bar_per = bar.get_value()
	if per-0.1 < bar_per < per+0.1:
		bar.set_value(per)
	else:
		bar_per += sign(per-bar_per) * (abs(per-bar_per)*0.05)
		bar.set_value(bar_per)
	bar.get_node('health').set_text(str(format._number(army.current_health),"/",format._number(army.army_health())))





func _ready():
	format = get_node('/root/formats')
	
	army = Army.new()
	army.new_army()
	bots_panel = get_node('Battle/cont/bots')
	mob_panel = get_node('Battle/cont/mobs')
	
	draw_bots_combat_info()
	
	
	set_process(true)





func _process(delta):
	var per = (army.current_health*1.0) / (army.army_health()*1.0)
	check_bots_healthbar(per)


