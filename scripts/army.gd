
extends Panel

### GLOBALS ###
var format
#links
var population
var construction

#army attributes
var troops = 1				#current no. of troops
var unit_damage = 3			#base damage per trooper
var damage_var = 0.4		#variation +- base damage
var unit_health= 10			#base HP per trooper
var unit_skills = {0:0, 1:0, 2:0}	#0=damage, 1=armor, 2=shields

var current_health
var total_health

var is_dead = true
var is_ready = false
var is_auto = false

### INIT ###
func _ready():
	format = get_node('/root/formats')
	population = get_node('/root/Game/population')
	construction = get_node('/root/Game/construction')
	get_node('/root/Game/combat').army = self

###	COMBAT ARMY FUNCTIONS	###
func reset():
	pass

func restore(source):
	pass

func save():
	var saveDict = {
	
		}
	return saveDict

### PUBLIC FUNCTIONS ###
func new_army():
	_set_troopers()
	set_equipment()
	set_total_health()
	current_health = total_health
	_draw_panel()

func attack():
	var dmg = _damage_range()
	randomize()
	return round(rand_range(dmg[0],dmg[1]))

func take_damage(dmg):
	var damage = max(0,dmg-get_shields())
	var new_health = self.current_health - damage
	if new_health <= 0:
		self.current_health = 0
		self._die()
	else:
		self.current_health = new_health

func set_total_health():
	set_armor()
	total_health = get_total_health()

func get_total_health():
	return (unit_health+unit_skills[1]) * troops

## get equipment lists
func get_weapons_list():
	_get_skill(0)

func get_armor_list():
	_get_skill(1)

func get_shields_list():
	_get_skill(2)
	

## set equipment
func set_equipment():
	for i in range(3):
		_set_skill(i)

func set_weapons():
	_set_skill(0)

func set_armor():
	_set_skill(1)

func set_shields():
	_set_skill(2)

# get stats
func get_shields():
	return unit_skills[2] * troops

func set_autofight(auto):
	is_auto = auto
func is_autofighting():
	return is_auto

func set_combat_ready(ready):
	is_ready = ready
func is_combat_ready():
	return is_ready

### PRIVATE FUNCTIONS ###
func _draw_panel():
	_draw_troopers()
	var per = current_health*1.0 / total_health*1.0
	_draw_healthbar(per)
	_draw_damage()
	_draw_shields()

func _draw_healthbar(per):
	var bar = get_node('healthbar')
	var show_v = bar.get_value()
	if per-0.05 < show_v < per+0.05:	#clamp to value if within threshold
		show_v = per
	else:	#otherwise, slide bar up or down
		show_v += sign(per - show_v) * (abs(per - show_v)*0.05)*2
	bar.set_value(show_v)

	var health_txt = format.number(current_health) + "/" + format.number(total_health)
	get_node('healthbar/health').set_text(health_txt)
	
	
func _draw_damage():
	var dmg = _damage_range()
	var dmg_txt = "Damage: " +format.number(dmg[0])+ "-" +format.number(dmg[1])
	get_node('damage').set_text(dmg_txt)

func _draw_shields():
	var sh = get_shields()
	var sh_txt = "Shields: " +format.number(sh)
	get_node('shields').set_text(sh_txt)

func _draw_troopers():
	var troop_txt = "Troopers (" +format.number(troops)+ ")"
	get_node('troops').set_text(troop_txt)



func _get_skill(skill):
	var data = []
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.level > 0:
				if struct.building.category == "Equipment":
					if struct.building.material == skill:
						var B = struct.building
						data.append({'name':B.name, 'lvl':B.level, 'factor':B.factor})
	return data

func _set_skill(skill):
	var value = 0
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == 'Equipment':
				if struct.building.material == skill:
					value += (struct.building.factor * struct.building.level)
	unit_skills[int(skill)] = value


func _set_troopers():
	var value = 0
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == "Tactics":
				value += struct.building.level
	var T = 1
	while value > 0:
		T += ceil(troops * 0.25)
		value -= 1
	troops = T

func _damage_range():
	var base_unit_dmg = unit_damage + unit_skills[0]
	var base_dmg = base_unit_dmg * troops
	var min_dmg = max(1, base_dmg * damage_var)
	var max_dmg = max(2, base_dmg * (1.0+damage_var))
	return [int(min_dmg), int(max_dmg)]

func _die():
	self.is_dead = true
	if not self.is_auto:
		self.combat_ready = false

### CHILD FUNCTIONS ###

