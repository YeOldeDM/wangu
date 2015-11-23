
extends Control

class Army:
	var troops = 1
	var damage = 5
	var damage_var = 0.4
	var unit_health = 5
	var defense = 0
	
	var current_health = 0
	
	func new_army():
		self.current_health = self.army_health
	
	func army_damage():
		var base_damage = self.damage * self.troops
		var min_dmg = ceil(base_damage*damage_var)
		var max_dmg = ceil(base_damage * (1.0+damage_var))
		return [min_dmg,max_dmg]
		
		
	func army_attack():
		var dmg = self.army_damage()
		return randi(dmg[0],dmg[1])
	
	func army_health():
		return self.unit_health * self.troops

	func army_defense():
		return self.defense * self.troops
	
	func army_get_hit(dmg):
		var damage = max(0,dmg-self.army_defense())
		self.current_health
		
func _ready():
	# Initialization here
	pass


