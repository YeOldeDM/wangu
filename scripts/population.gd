
extends Control


#################
#	GLOBALS		#
#################
var format
var metrics
var news
var construction

var land = 0
var population = {
			'current': 2,
			'max': 10,
			'rate': 0.01
			}
var workforce = {
			'current': 0,
			'max': 0
			}
			
var workers = {
		0: 0,
		1: 0,
		2: 0,
		3: 0,
		}



func reset():
	land = 0
	population['current'] = 0
	population['max'] = 10
	for i in range(4):
		workers[i] = 0
	_set_current_workforce()
	

func save():
	var saveDict = {
	'land':		land,
	'population':	population['current'],
	'workers':	{
		0:	workers[0],
		1:	workers[1],
		2:	workers[2],
		3:	workers[3]
		},
	'settings':	{
		'index':	0,
		'jobs':		1
		}
		
	}
	return saveDict

func restore(source):
	prints("Restoring Population:", source.keys() )
	
	land = source['land']
	population['current'] = source['population']
	for i in range(4):
		workers[i] = source['workers'][str(i)]
	
	set_max_population()
	_set_max_workforce()
	_set_current_workforce()
	_check_current_workforce()
	
	if 'settings' in source:
		_on_jobs_pressed(int(source['settings']['index']),int(source['settings']['jobs']))
	else:
		_on_jobs_pressed(0,1)
	

var worker_panels
var pop_panel

var jobs_buttons


#################
#	MAINLOOP	#
#################
func process(delta):
	var rate = 0.0
	if 2 <= int(population['current']):
		rate = population['current'] * population['rate']
	var new_pop = population['current'] + (rate * delta)
	if new_pop >= int(population['current']):
		var pop_plus = new_pop-population['current']
		metrics.total_bots += pop_plus
		_set_max_workforce()
		_refresh()
	population['current'] = clamp(new_pop, 0, population['max'])




#########################
#	PUBLIC FUNCTIONS	#
#########################

func gain_land(amt):
	land += amt
	set_max_population()

func set_max_population():
	var pop = 10 + land
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == 'Housing':
				pop += (struct.building.factor * struct.building.level)
	var old_pop = population['max']
	population['max'] = pop
	var diff = population['max'] - old_pop
	if diff > 0:
		news.message(str(diff)+" spaces have just opened up for new Bots!")
	if population['current'] > population['max']:	#If we get too many Bots:
		var diff = population['current'] - population['max']
		news.message("[color=red]"+str(diff)+" Bots could not fit in your Bot colony. They had to be put down.[/color]")
		population['current'] = population['max']
	_refresh()


func is_workforce_full():
	if workforce['current'] == workforce['max'] or workforce['current'] == int(population['current']):
		return true
	return false


#########################
#	PRIVATE FUNCTIONS	#
#########################
func _set_max_workforce():
	var old_force = workforce['max']
	workforce['max'] = min(int(population['max']/2), int(population['current']))
	var diff = workforce['max'] - old_force
	if diff > 0:
		news.message(str(str(diff)," new jobs have opened up. Get to work!"))


func _change_current_population(n):
	population['current'] += n
	_set_max_workforce()

func _check_current_workforce():
	if workforce['current'] > workforce['max']:	#Handle worker overflow bug
		for w in workers:
			workers[w] = 0
		_set_current_workforce()
		news.message("[b]Your workers went on strike! Whip those bots back into shape, son![/b]")
		_refresh()

func _set_current_workforce():
	var total = workers[0]+workers[1]+workers[2]+workers[3]
	workforce['current'] = total	#current workforce cannot exceed current population

func _get_total_jobs():
	return workers[0]+workers[1]+workers[2]+workers[3]
	
	
func _add_workers(mat,number):
	var jobs = _get_total_jobs()
	var new_total = jobs+number
	if workforce['max'] < new_total:
		number = workforce['max'] - jobs
	if abs(number) > 0:
		workers[mat] = max(0, workers[mat] + number)

#########################
#	GUI DRAW FUNCTION	#
#########################
func _refresh():
	#BUILD BUTTON (still hackish. For now, you can only build up to 2 bots. After that, they breed on their own.
	if int(population['current']) >= population['max'] or 1 < int(population['current']):
		get_node('home/build').set_disabled(true)
	else:
		if get_node('home/build').is_disabled():
			get_node('home/build').set_disabled(false)
	
	for i in range(4):
		if workers[i] <= 0:
			workers[i] = 0
			worker_panels[i].get_node('decrease').set_disabled(true)
		else:
			if worker_panels[i].get_node('decrease').is_disabled():
				worker_panels[i].get_node('decrease').set_disabled(false)
		if is_workforce_full():
			worker_panels[i].get_node('increase').set_disabled(true)
		else:
			if worker_panels[i].get_node('increase').is_disabled():
				worker_panels[i].get_node('increase').set_disabled(false)
		worker_panels[i].get_node('amt').set_text(str(workers[i]))
	pop_panel.get_node('pop').set_text(str(int(population['current']),"/",population['max']))
	pop_panel.get_node('labor').set_text(str(workforce['current'],"/",workforce['max']))
	var pop_per = int((population['current']*1.0/population['max']*1.0)*100)
	if pop_panel.get_node('fillbar').get_value() != pop_per:
		pop_panel.get_node('fillbar').set_value(pop_per)
	
	for i in range(4):
		get_node('/root/Game/Bank').bank[i]['producers']['workers'] = workers[i]

#############
#	INIT	#
#############
func _ready():
	format = get_node('/root/formats')
	metrics = get_node('/root/Game/Metrics')
	news = get_node('/root/Game/news')
	construction = get_node('/root/Game/construction')
	
	worker_panels = [
		get_node('Metal'),
		get_node('Crystal'),
		get_node('Nanium'),
		get_node('Tech')]
	pop_panel = get_node('home')
	
	jobs_buttons = [
		get_node('settings/jobs/jobs1'),
		get_node('settings/jobs/jobs10'),
		get_node('settings/jobs/jobs50'),
		get_node('settings/jobs/jobs100')]
		
	_set_max_workforce()
	_refresh()


#####################
#	CHILD SIGNALS	#
#####################
var job_interval = 1

func _on_decrease_pressed(index):
	_add_workers(index,-job_interval)
	#workers[index] -= 1
	_set_current_workforce()
	_refresh()


func _on_increase_pressed(index):
	_add_workers(index,job_interval)
	#workers[index] += 1
	_set_current_workforce()
	_refresh()


func _on_build_pressed():
	population['current'] += 1
	metrics.total_bots += 1
	_set_max_workforce()
	_refresh()


func _on_jobs_pressed(index,jobs):
	for i in range(4):
		if i == index:
			jobs_buttons[i].set_pressed(true)
			job_interval = jobs
		else:
			jobs_buttons[i].set_pressed(false)
	
