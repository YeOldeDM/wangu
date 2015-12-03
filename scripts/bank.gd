
extends Control


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
			3:		{'level': 0, 'rate': 0.25},
			4:		{'level': 0, 'rate': 0.1}}		#boost ALL

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


func save():
	var saveDict = {
	'bank': {
		0:		{'current': bank[0]['current'],
				'max':		bank[0]['max'],
				'producers':	{'workers':	bank[0]['producers']['workers']}
			},
		1:		{'current': bank[1]['current'],
				'max':		bank[1]['max'],
				'producers':	{'workers':	bank[1]['producers']['workers']}
			},
		2:		{'current': bank[2]['current'],
				'max':		bank[2]['max'],
				'producers':	{'workers':	bank[2]['producers']['workers']}
			},
		3:		{'current': bank[3]['current'],
				'max':		null,
				'producers':	{'workers':	bank[3]['producers']['workers']}
			},
		},
	'your_skills':	{
		0:	{
			'lvl':	your_skills[0]['lvl'],
			'xp':	your_skills[0]['xp']
			},
		1:	{
			'lvl':	your_skills[1]['lvl'],
			'xp':	your_skills[1]['xp']
			},
		2:	{
			'lvl':	your_skills[2]['lvl'],
			'xp':	your_skills[2]['xp']
			},
		3:	{
			'lvl':	your_skills[3]['lvl'],
			'xp':	your_skills[3]['xp']
			},
		},
	}
	return saveDict



var worker_base_skill = 0.5



var buttons
var panels
var skill_panels

var format

var draw_timer = 0
var draw_tick = 0.1

#################
#	MAIN-LOOP	#
#################
func process(delta):
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
		
	
	#tick draw clock
	draw_timer += delta
	if draw_timer >= draw_tick:
		draw_timer = 0
		_draw_gui()




#########################
#	PUBLIC FUNCTIONS	#
#########################


func gain_xp(i,amt):
	#gain XP in i skill
	var lvl = your_skills[i]['lvl']
	your_skills[i]['to-next'] = _get_skill_level(lvl+1)
	your_skills[i]['xp'] += amt
	if your_skills[i]['xp'] >= your_skills[i]['to-next']:
		your_skills[i]['lvl'] += 1
		your_skills[i]['to-next'] = _get_skill_level(your_skills[i]['lvl']+1)
		
		var gui_ref = {
			0: 'Metal',
			1: 'Crystal',
			2: 'Nanium',
			3: 'Tech'}
		var path = 'skills/'+gui_ref[i]+'/Lup'
		get_node(path).set_emitting(true)
	
func set_storage(mat):
	#set max storage for resources
	var amt = 100
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == 'Storage':
				if struct.building.material == int(mat):
					for l in range(struct.building.level):
						amt *= 2
	bank[int(mat)]['max'] = amt
	_draw_gui()

func can_afford(mat, amt):
	#check if there are currently enough of a resource to spend x amt
	var bank_amt = bank[mat]['current']
	return int(amt) <= int(bank_amt)

func gain_resource(mat, amt):
	#gain resources
	var value = _get_resource(mat)
	value += amt
	_set_resource(mat, value)

func spend_resource(mat, amt):
	#spend resources. Assumes we can afford the cost
	var value = _get_resource(mat)
	value -= amt
	_set_resource(mat, value)

func get_boost(mat):
	#get current boost rate based on boost level
	var value = 1.0
	for i in range(boost[mat]['level']):
		value += (value * boost[mat]['rate'])
	for i in range(boost[4]['level']):
		value += (value * boost[4]['rate'])
	return value

func set_boost(material):
	var level = 0
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == 'Boost':
				if struct.building.material == material:
					level += struct.building.level
	boost[material]['level'] = level


func get_workers(mat):
	#get current amount of workers for resource
	var pro = bank[mat]['producers']
	return pro['workers']

func set_workers(mat, amount):
	#set amount of workers for resources
	var pro = bank[mat]['producers']
	pro['workers'] = amount





#########################
#	PRIVATE FUNCTIONS	#
#########################
func _get_skill_level(L):
	var B = 20
	var R = 50
	if L <= 0:
		return 0
	else:
		return _get_skill_level(L-1) + B + (R*max(0,L-2))

func _set_resource(mat,amt):
	#set current resource value. Clamp to max resource storage
	if bank[mat]['max'] != null:
		if amt >= bank[mat]['max']:
			amt = bank[mat]['max']
	bank[mat]['current'] = max(0,amt)

func _get_resource(mat):
	#return current resources
	return bank[mat]['current']




#########################
#	GUI DRAW FUNCTION	#
#########################
func _draw_gui():
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
		
		var xp_needed = _get_skill_level(real_lvl+1) - _get_skill_level(real_lvl)
		var xp_progress = your_skills[i]['xp'] - _get_skill_level(real_lvl)
		var skill_per = xp_progress / max(1,xp_needed)
		if show_per != skill_per:
			skill_panels[i].get_node('fillbar').set_value(skill_per)


#############
#	INIT	#
#############
var construction

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
	construction = get_node('/root/Game/construction')
#####################
#	CHILD SIGNALS	#
#####################
func _on_use_toggled( pressed,index ):
	#toggling this material's player-grind status
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