
extends TextureButton

var colors = {
	0:	Color(1.0,1.0,1.0),
	1:	Color(0.0,1.0,0.0),
	2:	Color(1.0,1.0,0.0)}

var status = 0

func change_color(style):
	#style: 0=red(wild), 1=green(conquered), 2=yellow(active)
	set_modulate(colors[style])

func set_loot_frame(frame):
	get_node('loot').set_frame(frame)
	



