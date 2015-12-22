
extends Control


var army
var mob
var map

var format
var bank
var population
var news
var construction

var battle_clock = 0.0
var turn_duration = 0.75

func _ready():
	format = get_node('/root/formats')
	bank = get_node('/root/Game/Bank')
	population = get_node('/root/Game/population')
	news = get_node('/root/Game/news')
	construction = get_node('/root/Game/construction')

	army = get_node('Battle/cont/bots')
	mob = get_node('Battle/cont/mobs')
	map = get_node('Battle/map')

func reset():
	if map:
		map.generate_map()
	if army:
		army.new_army()
	if mob:
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
	if army:
		army.blit_healthbar()
	if mob:
		mob.blit_healthbar()
	
func _combat():
	if not army.is_dead and not mob.is_dead:	#both sides active
		#Army is still living..
		if army.is_ready or army.is_auto:
			printt(army.is_ready, army.is_auto)
			var army_dmg = army.attack()	#roll damage
			mob.take_damage(army_dmg)		#apply damage
		#Mob counters if still living
			if not mob.is_dead:
				var mob_dmg = mob.attack()
				army.take_damage(mob_dmg)

	else:	#army or mob is dead
		if army.is_dead:
			if army.is_auto:
				army.new_army()
		elif mob.is_dead:
			var mob_name = mob.mob_name
			mob.new_mob()
			map.next_cell(mob_name)

