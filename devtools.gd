
extends WindowDialog

var bank
var tab

func _ready():
	tab = get_node('tab')
	for i in range(4):
		_on_get_pressed(i)
		_on_get_bank_pressed(i)





func _on_set_pressed(index):
	var workers = tab.get_child(tab.get_current_tab()).get_node('cont/labor/workers').get_value()
	var worker_rate = tab.get_child(tab.get_current_tab()).get_node('cont/labor/basemod').get_value()
	bank.set_workers(index,workers)
	bank.worker_base_skill = worker_rate
	
	var boost_lvl = tab.get_child(tab.get_current_tab()).get_node('cont/labor/boost').get_value()
	var boost_rate = tab.get_child(tab.get_current_tab()).get_node('cont/labor/boostmod').get_value()
	bank.boost[index]['level'] = boost_lvl
	bank.boost[index]['rate'] = boost_rate

func _on_get_pressed(index):
	var workers = bank.get_workers(index)
	var worker_rate = bank.worker_base_skill
	tab.get_child(tab.get_current_tab()).get_node('cont/labor/workers').set_value(workers)
	tab.get_child(tab.get_current_tab()).get_node('cont/labor/basemod').set_value(worker_rate)
	
	var boost_lvl = bank.boost[index]['level']
	var boost_rate = bank.boost[index]['rate']
	tab.get_child(tab.get_current_tab()).get_node('cont/labor/boost').set_value(boost_lvl)
	tab.get_child(tab.get_current_tab()).get_node('cont/labor/boostmod').set_value(boost_rate)


func _on_get_bank_pressed(index):
	var mat_amt = bank.bank[index]['current']
	var mat_max = bank.bank[index]['max']
	tab.get_child(tab.get_current_tab()).get_node('cont/bank/current').set_text(str(mat_amt))
	if index < 3:
		tab.get_child(tab.get_current_tab()).get_node('cont/bank/max').set_text(str(mat_max))


func _on_set_bank_pressed(index):
	var mat_amt = tab.get_child(tab.get_current_tab()).get_node('cont/bank/current').get_text()
	if index < 3:
		var mat_max = tab.get_child(tab.get_current_tab()).get_node('cont/bank/max').get_text()
		bank.bank[index]['max'] = float(mat_max)
		bank.set_resource(index,float(mat_amt))
	_on_get_bank_pressed(index)


func _on_fill_bank_pressed(index):
	bank.set_resource(index,bank.bank[index]['max'])
	_on_get_bank_pressed(index)
