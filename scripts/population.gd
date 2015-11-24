
extends Control

var population = {
			'current': 0,
			'max': 50,
			'rate': 0
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

var worker_panels
var pop_panel

func _ready():
	worker_panels = [
		get_node('Metal'),
		get_node('Crystal'),
		get_node('Nanium'),
		get_node('Tech')]
	pop_panel = get_node('home')
	_set_max_workforce()
	refresh()


func refresh():
	if population['current'] >= population['max']:
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
	pop_panel.get_node('pop').set_text(str(population['current'],"/",population['max']))
	pop_panel.get_node('labor').set_text(str(workforce['current'],"/",workforce['max']))
	var pop_per = int((population['current']*1.0/population['max']*1.0)*100)
	if pop_panel.get_node('fillbar').get_value() != pop_per:
		pop_panel.get_node('fillbar').set_value(pop_per)
		
func _set_max_workforce():
	workforce['max'] = min(int(population['max']/2), population['current'])

func _set_current_workforce():
	var total = workers[0]+workers[1]+workers[2]+workers[3]
	workforce['current'] = total	#current workforce cannot exceed current population

func is_workforce_full():
	if workforce['current'] == workforce['max'] or workforce['current'] == population['current']:
		return true
	return false
	

func _on_decrease_pressed(index):
	workers[index] -= 1
	_set_current_workforce()
	refresh()


func _on_increase_pressed(index):
	workers[index] += 1
	_set_current_workforce()
	refresh()


func _on_build_pressed():
	population['current'] += 1
	_set_max_workforce()
	refresh()