
extends Control

const metal=0
const crystal=1
const nanium=2
const tech=3

var time = 0.0

var bank = {0:	{'current': 0, 'max': 100, 
			'rate': 0, 'producers':	{'you':0,
									'workers':0}},
			1:	{'current': 0, 'max': 100, 
			'rate': 0, 'producers':	{'you':0,
									'workers':0}},
			2:	{'current': 0, 'max': 100, 
			'rate': 0, 'producers':	{'you':0,
									'workers':0}},
			3:	{'current': 0, 'max': null,
			'rate': 0, 'producers':	{'you':0,
									'workers':0}},
			}

var boost = {0:		{'level': 0, 'rate': 0.25},
			1:		{'level': 0, 'rate': 0.25},
			2:		{'level': 0, 'rate': 0.25},
			3:		{'level': 0, 'rate': 0.25}}

var skills = ['Salvage','Harvest','Mine','Research']
var skills2 = ['Salvaging','Harvesting','Mining','Researching']

var your_base_skill = 1.0
var your_skills = {
		0:	{'name':	'Salvage',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
		1:	{'name':	'Harvest',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
		2:	{'name':	'Mine',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
		3:	{'name':	'Research',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
			}
func get_skill_level(L):
	var B = 20
	var R = 50
	if L <= 0:
		return 0
	else:
		return get_skill_level(L-1) + B + (R*max(0,L-2))
		
var worker_base_skill = 0.5
var worker_skills = {
		0:	{'name':	'Salvage',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
		1:	{'name':	'Harvest',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
		2:	{'name':	'Mine',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
		3:	{'name':	'Research',
			'lvl':	0,	'xp':	0,
			'to-next':	0},
			}


var buttons
var panels
var skill_panels

var format

var draw_timer = 0
var draw_tick = 0.1

func _ready():
	buttons = [
	get_node('Metal/use'),
	get_node('Crystal/use'),
	get_node('Nanium/use'),
	get_node('Tech/use')]
	
	panels = [
	get_node('Metal'),
	get_node('Crystal'),
	get_node('Nanium'),
	get_node('Tech')]
	
	skill_panels = [
	get_node('skills/Metal'),
	get_node('skills/Crystal'),
	get_node('skills/Nanium'),
	get_node('skills/Tech'),
	get_node('skills/total')]
	
	format = get_node('/root/formats')
	set_process(true)

func _process(delta):
	#adjust resource levels by income
	for i in range(4):
		var mat_amt = bank[i]['current']
		var mat_max = bank[i]['max']
		
		var your_production_rate = bank[i]['producers']['you'] * max(1.0,(your_base_skill))
		var your_production_boost = your_production_rate * (your_skills[i]['lvl']* 0.05 )
		var worker_production_rate = bank[i]['producers']['workers'] * worker_base_skill
		var boost_rate = get_boost(i)
		var total_rate = (your_production_rate + your_production_boost + worker_production_rate) * boost_rate
		bank[i]['rate'] = total_rate
		var new_amt = mat_amt + (bank[i]['rate']*delta)
		if mat_max and new_amt >= mat_max:
			new_amt = mat_max
		else:
			gain_xp(i,your_production_rate*boost_rate*delta)	#don't gain xp if this bank is full!
		bank[i]['current'] = new_amt
		
	#count up time	
	time += delta
		
	
	#tick draw clock
	draw_timer += delta
	if draw_timer >= draw_tick:
		draw_timer = 0
		_draw_gui()

func _draw_gui():
	get_node('time').set_text(str("Time: ",format._time(int(time))))
	
	var total_skill = 0
	for i in range(4):
		total_skill += your_skills[i]['lvl']
	skill_panels[4].get_node('total_lvl').set_text(str(total_skill))
	
	
	for i in range(4):
		var mat_rate = bank[i]['rate']
		panels[i].get_node('rate').set_text(str("+",format._number(mat_rate),"/s"))
		
		var mat_amt = bank[i]['current']
		var mat_max = bank[i]['max']
		var mat_txt = ""
		if mat_max:
			mat_txt = str(format._number(int(mat_amt)),"/",format._number(mat_max))
		else:
			mat_txt = str(format._number(int(mat_amt)))
		panels[i].get_node('bank').set_text(mat_txt)
		
		if i < 3:
			var per = mat_amt/max(1,mat_max)

			panels[i].get_node('fillbar').set_value(per)
		
		var show_lvl = int(skill_panels[i].get_node('lvl').get_text())
		var real_lvl = your_skills[i]['lvl']
		if show_lvl != real_lvl:
			skill_panels[i].get_node('lvl').set_text(str(real_lvl))
			
		var show_per = skill_panels[i].get_node('fillbar').get_value()
		
		var xp_needed = get_skill_level(real_lvl+1) - get_skill_level(real_lvl)
		var xp_progress = your_skills[i]['xp'] - get_skill_level(real_lvl)
		var skill_per = xp_progress / max(1,xp_needed)
		if show_per != skill_per:
			skill_panels[i].get_node('fillbar').set_value(skill_per)
		
	
		

func gain_xp(i,amt):
	var lvl = your_skills[i]['lvl']
	your_skills[i]['to-next'] = get_skill_level(lvl+1)
	your_skills[i]['xp'] += amt
	if your_skills[i]['xp'] >= your_skills[i]['to-next']:
		your_skills[i]['lvl'] += 1
		your_skills[i]['to-next'] = get_skill_level(your_skills[i]['lvl']+1)
	

func set_resource(material,amt):
	if amt >= bank[material]['max']:
		amt = bank[material]['max']
	bank[material]['current'] = amt

func get_boost(material):
	var value = 1.0
	for i in range(boost[material]['level']):
		value += value*boost[material]['rate']
	return value
	

func get_workers(material):
	var pro = bank[material]['producers']
	return pro['workers']

func set_workers(material, amount):
	var pro = bank[material]['producers']
	pro['workers'] = amount

func _on_use_toggled( pressed,index ):
	var current_skill = null
	if pressed:
		current_skill = index
	else:
		current_skill = null
		

	for i in range(4):
		if i == current_skill:
			buttons[i].get_node('Label').set_text(skills2[i])
			bank[i]['producers']['you']=1
		else:
			buttons[i].get_node('Label').set_text(skills[i])
			if buttons[i].is_pressed():
				buttons[i].set_pressed(false)
			bank[i]['producers']['you']=0
		