
extends TextureButton

var colors = {
	0:	Color(1.0,1.0,1.0),
	1:	Color(0.0,1.0,0.0),
	2:	Color(1.0,1.0,0.0)}

var level = 0

var status = 0
var loot_type = 5
var loot_amt = 0
var loot_chance = 0.44
var loot_var = 0.2

func _set_loot_frame(loot_type):
	get_node('loot').set_frame(loot_type)
	
func make_loot():
	randomize()
	if rand_range(0.0,1.0) <= loot_chance:
		var min_loot = max(1, level * loot_var)
		var max_loot = max(1, level * (1.0+loot_var))
		randomize()
		loot_amt = max(1,round(rand_range(min_loot,max_loot)))
		loot_type = round(rand_range(0,4))
		#print("MADE LOOT")
	_set_loot_frame(loot_type)

func make_wild():
	status = 0
	set_modulate(colors[status])

func make_conquered():
	status = 1
	set_modulate(colors[status])

func make_active():
	status = 2
	set_modulate(colors[status])