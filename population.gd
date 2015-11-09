
extends Control

var population = {
			'current': 50,
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
	print(worker_panels)

func refresh():
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
	
func _set_max_workforce():
	workforce['max'] = int(population['max']/2)

func _set_current_workforce():
	var total = workers[0]+workers[1]+workers[2]+workers[3]
	workforce['current'] = total

func is_workforce_full():
	var passed = workforce['current'] == workforce['max']
	return passed
	

func _on_decrease_pressed(index):
	workers[index] -= 1
	_set_current_workforce()
	refresh()


func _on_increase_pressed(index):
	workers[index] += 1
	_set_current_workforce()
	refresh()
