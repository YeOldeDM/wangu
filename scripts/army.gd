
extends Panel

### GLOBALS ###
var format

#links
var combat
var population
var construction



#army attributes
var troops = 1				#current no. of troops
var unit_damage = 3			#base damage per trooper
var damage_var = 0.4		#variation +- base damage
var unit_health= 10			#base HP per trooper
var unit_skills = {0:0, 1:0, 2:0}	#0=damage, 1=armor, 2=shields

var current_health = 0
var total_health = 0

var is_dead = true
var is_ready = false
var is_auto = false

### INIT ###
func _ready():
	format = get_node('/root/formats')
	
	combat = get_node('/root/Game/combat')
	population = get_node('/root/Game/population')
	construction = get_node('/root/Game/construction')
	get_node('/root/Game/combat').army = self

###	COMBAT ARMY FUNCTIONS	###
#..we might not need any of these..#
func reset():
	restore(null)

func restore(source):
	_set_troopers()
	set_all_equipment()
	_draw_panel()

func save():
	var saveDict = {

		}
	return saveDict

### PUBLIC FUNCTIONS ###
func new(from_pool=true):
	_set_troopers()
	set_all_equipment()
	set_total_health()
	if from_pool == true:
		var pop = population.population['current'] - population.workforce['current']
		if pop >= troops+1:
			population._change_current_population(-1*troops)
		else:
			return
	current_health = total_health
	_draw_panel()
	
	is_ready = false

	is_dead = false

func attack():
	if is_ready:
		var dmg = _damage_range()
		randomize()
		var damage =  round(rand_range(dmg[0],dmg[1]))
		return damage
		print("Army deals "+str(damage)+" damage!")
	else:
		print("Army isn't ready")
		return -1

func take_damage(dmg):
	var damage = max(0,dmg-get_shields())
	var new_health = current_health - damage
	if new_health <= 0:
		current_health = 0
#		self._die()
	else:
		current_health = new_health

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
func set_equipment(equip):
	_set_skill(equip)

	
func set_all_equipment():
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

func blit_healthbar():
	#slide healthbar if needed
	var per = (current_health*1.0) / (total_health*1.0)
	_draw_healthbar(per)

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
	if show_v <= 0.01:
		_die()
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
	var total = 0
	if skill == 0:
		data.append({'name':'base', 'lvl':1, 'factor':unit_damage})
	elif skill == 1:
		data.append({'name':'base', 'lvl':1, 'factor':unit_health})
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
		T += ceil(T * 0.25)
		value -= 1
	troops = T

func _damage_range():
	var base_unit_dmg = unit_damage + unit_skills[0]
	var base_dmg = base_unit_dmg * troops
	var min_dmg = max(1, base_dmg * damage_var)
	var max_dmg = max(2, base_dmg * (1.0+damage_var))
	return [int(min_dmg), int(max_dmg)]

func _die():
	is_dead = true
	if is_auto:
		is_ready = true
	else:
		is_ready = false



### CHILD FUNCTIONS ###
func _on_fight_pressed():
	is_ready = true

func _on_auto_fight_toggled( pressed ):
	is_auto = pressed


func _on_info_mouse_enter(title,index):
	var data = [ title, _get_skill(index) ]
	#combat.show_info(data)


func _on_info_mouse_exit():
	#combat.info.hide()
	pass

