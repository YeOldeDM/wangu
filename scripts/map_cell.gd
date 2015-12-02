
extends TextureButton

var colors = {
	0:	Color(1.0,1.0,1.0),
	1:	Color(0.0,1.0,0.0),
	2:	Color(1.0,1.0,0.0)}

var status = 0
var loot_type = 5
var loot_amt = 0
var loot_chance = 0.28

func change_color(style):
	#style: 0=red(wild), 1=green(conquered), 2=yellow(active)
	set_modulate(colors[style])

func set_loot_frame(frame):
	get_node('loot').set_frame(frame)
	
func make_loot(l):
	l *= 3.14	#cuz why not
	randomize()
	if rand_range(0.0,1.0) <= loot_chance:
		var loot_var = 0.3
		var min_loot = max(1,(l*loot_var))
		var max_loot = (l*(1.0+loot_var))
		randomize()
		loot_amt = max(1,round(rand_range(min_loot,max_loot)))
		randomize()
		loot_type = round(rand_range(0,3))
		print("MADE LOOT")
	set_loot_frame(loot_type)



