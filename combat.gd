
extends Control


var army
var mob
var map

var format = get_node('/root/formats')
var bank = get_node('/root/Game/Bank')
var population = get_node('/root/Game/population')
var news = get_node('/root/Game/news')
var construction = get_node('/root/Game/construction')

var battle_clock = 0.0
var turn_duration = 0.75

func _ready():
	pass
#	army = get_node('bots')
#	mob = get_node('mobs')
#	map = get_node('map')

func reset():
	map.generate_map()
	army.new_army()
	mob.new_mob()

func restore(source):
	army.restore(source['army'])
	mob.restore(source['mob'])
	map.restore(source['map'])

func save():
	var saveDict = {
		'army':	army.save(),
		'mob':	mob.save(),
		'map':	map.save()
		}
	return saveDict

func process(delta):
	if battle_clock >= turn_duration:
		battle_clock = 0.0
		_combat()
	else:
		battle_clock += delta

func _combat():
	if not army.is_dead and not mob.is_dead:	#both sides active
		#Army is still living..
		if army.is_ready:
			var army_dmg = army.attack()	#roll damage
			mob.take_damage(army_dmg)		#apply damage
		#Mob counters if still living
		if not mob.is_dead:
			var mob_dmg = mob.attack()
			army.take_damage(mob_dmg)

	else:	#army or mob is dead
		if army.is_dead:
			if army.is_ready:
				army.new_army()
		elif mob.is_dead:
			map.next_cell()
			mob.new_mob()

