extends Control

var format

var game
var population
var news

var army
var mob
var map

var clock = 0.0
var round_length = 1.0

func _ready():
	format = get_node('/root/formats')
	
	game = get_parent()
	population = game.get_node('population')
	news = game.get_node('news')


	army = get_node('Battle/cont/bots')
	mob = get_node('Battle/cont/mobs')
	map = get_node('Battle/map')

	army.new()
	mob.new()
	map.generate_map()

func reset():
	army.reset()
	mob.reset()
	map.reset()

func save():
	var saveDict = {
		'army':	army.save(),
		'mob':	mob.save(),
		'map':	map.save()
			}
	return saveDict

func restore(data):
	army.restore(data['army'])
	mob.restore(data['mob'])
	map.restore(data['map'])



func process(delta):
	if clock <= round_length:
		clock += delta
	else:
		clock = 0
		_combat_tick()

	army.blit_healthbar()
	mob.blit_healthbar()

func _combat_tick():
	if not army.is_dead:
		if army.is_auto:
			army.is_ready = true
		print("ATTACK \n ===============")
		var atk = army.attack()
		if atk > -1 and not mob.is_dead:
			mob.take_damage(atk)
	else:
		army.new(true)
		return

	if not mob.is_dead:
		var atk = mob.attack()
		if not army.is_dead and army.is_ready:
			army.take_damage(atk)
	else:
		map.next_cell(mob.mob_name)
		mob.new()
