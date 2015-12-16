
extends Control

#Le Banque Grotesque
var bank = {0:	{'current': 0, 'max': 100, 
				'rate': {
					'from_you':	0,
					'from_workers':	0,
					'base_rate':	0,
					'boost_rate':	0,
					'total_rate':	0
					}, 
				'producers': {
					'you':0,
					'workers':0
					}
				},
			1:	{'current': 0, 'max': 100, 
				'rate': {
					'from_you':	0,
					'from_workers':	0,
					'base_rate':	0,
					'boost_rate':	0,
					'total_rate':	0
					}, 
				'producers': {
					'you':0,
					'workers':0
					}
				},
			2:	{'current': 0, 'max': 100, 
			'rate': {
					'from_you':	0,
					'from_workers':	0,
					'base_rate':	0,
					'boost_rate':	0,
					'total_rate':	0
					}, 
				'producers': {
					'you':0,
					'workers':0
					}
				},
			3:	{'current': 0, 'max': null,
			'rate': {
					'from_you':	0,
					'from_workers':	0,
					'base_rate':	0,
					'boost_rate':	0,
					'total_rate':	0
					}, 
				'producers': {
					'you':0,
					'workers':0
					}
				},
			}



#Income Boost dictionary
var boost = {0:		{'level': 0, 'rate': 0.25},
			1:		{'level': 0, 'rate': 0.25},
			2:		{'level': 0, 'rate': 0.25},
			3:		{'level': 0, 'rate': 0.25},
			4:		{'level': 0, 'rate': 0.1}}		#boost ALL

#References for label text
var skills = ['Salvage','Harvest','Mine','Research']
var skills2 = ['Salvaging','Harvesting','Mining','Researching']

#Grinding base skill
var your_base_skill = 1.0

#Worker base skill
var worker_base_skill = 0.5

#Grinding skill dict
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


func reset():
	for i in range(4):
		set_storage(i)
		_set_resource(i,0)
		your_skills[i]['lvl'] = 0
		your_skills[i]['xp'] = 0
		bank[i]['producers']['you'] = 0
		
		if i < 3:
			set_storage(i)
		set_boost(i)
	set_boost(4)
	get_node('Metal/use').set_pressed(false)
	get_node('Crystal/use').set_pressed(false)
	get_node('Nanium/use').set_pressed(false)
	get_node('Tech/use').set_pressed(false)
	
	print("RESET BANK")
	
#RESTORE BANK DATA
func restore(source):
	prints("Restoring Bank:", source.keys() )
	for i in range(4):
		#Set Current resource levels
		bank[i]['current'] = source['resources'][str(i)]
		
		#Set Grind skills
		your_skills[i]['lvl'] = source['your_skills'][str(i)]['lvl']
		your_skills[i]['xp'] = source['your_skills'][str(i)]['xp']
		
		#Set storage limits
		if i < 3:
			set_storage(int(i))
		
		#Set Boost rates
		set_boost(int(i))
	set_boost(4) #set All's boost as well
	
	#Set active grind skill
	if 'your_active_skill' in source:
		_on_use_toggled(1, source['your_active_skill'])
		var gui_ref = {
			0: 'Metal',
			1: 'Crystal',
			2: 'Nanium',
			3: 'Tech'}
		get_node(gui_ref[int(source['your_active_skill'])]+'/use').set_pressed(true)

#SAVE BANK DATA
func save():
	var saveDict = {
	#Store current resource levels
	'resources': {
		0:		bank[0]['current'],
		1:		bank[1]['current'],
		2:		bank[2]['current'],
		3:		bank[3]['current']
		},
	#Store skill levels and XP
	'your_skills':	{
		0:	{
			'lvl':	your_skills[0]['lvl'],
			'xp':	(your_skills[0]['xp'])
			},
		1:	{
			'lvl':	your_skills[1]['lvl'],
			'xp':	(your_skills[1]['xp'])
			},
		2:	{
			'lvl':	your_skills[2]['lvl'],
			'xp':	(your_skills[2]['xp'])
			},
		3:	{
			'lvl':	your_skills[3]['lvl'],
			'xp':	(your_skills[3]['xp'])
			},
		},
	}

	#Store grind button status
	var active_skill = -1
	for i in range(4):
		if bank[i]['producers']['you'] > 0:
			active_skill = i
			continue
	if active_skill >= 0:
		saveDict['your_active_skill'] = active_skill
	else:
		print("BAD ACTIVE SKILL, NOT STORED")
	return saveDict






#Links to UI elements
var buttons
var panels
var skill_panels

#format import
var format

#Draw timer (so we don't need to draw every frame)
var draw_timer = 0
var draw_tick = 0.1

var skill_bonus = 1.0

#################
#	MAIN-LOOP	#
#################
func process(delta):
	#adjust resource levels by income
	for i in range(4):
		var mat_amt = bank[i]['current']
		var mat_max = bank[i]['max']
		
		#Define rates & Do the maths
		bank[i]['rate']['from_you'] = bank[i]['producers']['you'] * (your_base_skill + (your_skills[i]['lvl']*skill_bonus))
		bank[i]['rate']['from_workers'] = bank[i]['producers']['workers'] * worker_base_skill
		
		bank[i]['rate']['base_rate'] = bank[i]['rate']['from_you'] + bank[i]['rate']['from_workers']
		
		bank[i]['rate']['boost_rate'] = bank[i]['rate']['base_rate'] * get_boost(i)
		
		bank[i]['rate']['total_rate'] = bank[i]['rate']['base_rate']
		
		#Only apply Boost if there is some base production also
		if bank[i]['rate']['total_rate'] > 0:
			bank[i]['rate']['total_rate'] += bank[i]['rate']['boost_rate']
		
		#Calculate new value
		var new_amt = mat_amt + (bank[i]['rate']['total_rate']*delta)
		
		#Clamp to storage limit:
		if mat_max and new_amt >= mat_max:
			new_amt = mat_max
		#..else don't gain xp if this bank is full!
		else:
			gain_xp(i, bank[i]['rate']['from_you'] * delta)	
		
		#Update the bank with the new amount
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
		var txt = "Your skill in " + skills2[i] + " has risen to level " +str(your_skills[i]['lvl']) + "!"
		news.message(txt)
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
	var mat_boost = boost[mat]['level'] * boost[mat]['rate']
	var all_boost = boost[4]['level'] * boost[4]['rate']
	var value = mat_boost + all_boost
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
	var B = 50
	var R = 100
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
		var mat_rate = bank[i]['rate']['total_rate']
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
			var filltime = "infinite"
			var diff = mat_max - mat_amt
			if diff <= 0:
				filltime = "FULL"
			elif mat_rate > 0:
				filltime = "Full in " + format._verbose_time((mat_max - mat_amt) / mat_rate)
			panels[i].get_node('fillbar/filltime').set_text(filltime)
			
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
var news
var game

func _ready():
	game = get_node('/root/Game')

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
	news = get_node('/root/Game/news')
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


var current_mat_moused = null



#repeat x3
func _on_Metal_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 0
		get_node('skills/skillpop').popup()

func _on_Crystal_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 1
		get_node('skills/skillpop').popup()

func _on_Nanium_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 2
		get_node('skills/skillpop').popup()

func _on_Tech_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 3
		get_node('skills/skillpop').popup()



func _on_skillbox_mouse_exit():
	get_node('skills/skillpop').hide()
	current_mat_moused = null


func _on_skillpop_about_to_show():
	var popup = get_node('skills/skillpop')
	raise()
	popup.raise()
	if current_mat_moused != null:
			#Get data
		var csm = current_mat_moused
		var skill_name = skills2[csm]
		var skill_lvl = your_skills[csm]['lvl']
		var skill_rate = 1.0 + (skill_lvl*skill_bonus)
		var skill_xp = [int(your_skills[csm]['xp']),
						int(your_skills[csm]['to-next'])]
			#Show data
		popup.get_node('skill_name').set_text(skill_name)
		popup.get_node('skill_lvl').set_text("level "+str(skill_lvl))
		popup.get_node('skill_grind').set_text("+"+str(skill_rate)+"/s")
		popup.get_node('skill_xp').set_text("XP "+str(skill_xp[0])+"/"+str(skill_xp[1]))
	
			#Set position
		var m_pos = get_tree().get_root().get_mouse_pos()
		m_pos.x += 10
		m_pos.y += 10
		popup.set_pos(m_pos)
	


func _on_metal_rate_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 0
		get_node('ratepop').popup()

func _on_crystal_rate_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 1
		get_node('ratepop').popup()

func _on_nanium_rate_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 2
		get_node('ratepop').popup()

func _on_tech_rate_mouse_enter():
	if not game.is_menu_open:
		current_mat_moused = 3
		get_node('ratepop').popup()


func _on_rate_mouse_exit():
	current_mat_moused = null
	get_node('ratepop').hide()



func _on_ratepop_about_to_show():
	var popup = get_node('ratepop')
	raise()
	popup.raise()
		#Get data
	if current_mat_moused != null:
		var cmm = current_mat_moused

		var you_base = bank[cmm]['producers']['you']
		var you_pro = bank[cmm]['rate']['from_you']
		
		var workers_q = bank[cmm]['producers']['workers']
		var worker_base = worker_base_skill
		var worker_pro = bank[cmm]['rate']['from_workers']
		
		var boost_per = get_boost(cmm)
		var boost_pro = bank[cmm]['rate']['boost_rate']
		
		var total_pro = bank[cmm]['rate']['total_rate']
		
		var mats = {
			0:	'Metal',
			1:	'Crystal',
			2:	'Nanium',
			3:	'Tech'
				}
		#Show data
		popup.get_node('rate_name').set_text(mats[cmm]+" production")
		
		popup.get_node('you_base').set_text(format._number(you_base))
		popup.get_node('you_pro').set_text("+"+format._number(you_pro))
		
		popup.get_node('workers_q').set_text("x"+format._number(workers_q))
		popup.get_node('worker_base').set_text(format._number(worker_base))
		popup.get_node('worker_pro').set_text("+"+format._number(worker_pro))
		
		popup.get_node('boost_per').set_text(format._number(boost_per*100)+"%")
		popup.get_node('boost_pro').set_text(format._number(boost_pro))
		
		popup.get_node('total_pro').set_text("Net Total: +"+format._number(total_pro))
		
		#Set position
	var m_pos = get_tree().get_root().get_mouse_pos()
	m_pos.x += 10
	m_pos.y += 10
	popup.set_pos(m_pos)