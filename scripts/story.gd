
extends Control

var game
var current_event = 0
var event_object = {-1: null}



#	EVENT SENSORS
var events = [
	{	#0
		'condition':	null,
		'message':	"""
You awake from your cryo-pod and climb out of the impact crater. The landscape 
around you is littered with scrap metal. Maybe you can do something useful with it.
"""
	},
	{	#1
		'condition':	['bank', 0, 15],	#bank 25 metal
		'message':	"""
A large building is discovered! It appears to be an old automated scrapyard.
You should be able to stash your gathered Metal here.
"""
	},
	{	#2
		'condition':	['skill',0,1],
		'message':	"""
You've gotten pretty good at gathering Metal! How 'bout you try harvesting some 
of the large crystal structures you see growing out of the dirt. The Crystal here
seems to show interesting energy-conduction properties.
"""
	},
	{	#3
		'condition':	['bank',1,50],
		'message':	"""
What is this?! You come across an abandoned Bot auto-factory. If you can build a
couple of these guys, they could help you gather resources.
"""
	},
	{	#4
		'condition':	['population', 3],
		'message':	"""
The Bots seem to be capable of self-replication! Now you know how robot babies are
made. You cannot bear to watch...yet you dare not look away!
"""
	},
	{	#5
		'condition':	['population', 5],
		'message':	"""
Things are getting crowded around here! You can start building [b]Shacks[/b] to house Bots
in.
"""
	},
	{	#6
		'condition':	['bank',1,100],
		'message':	"""
A curious Bot grabs your space-sleeve and drags you to a hidden location. It looks like this
little fella has discovered a vast network of caves! For some reason, this looks like the perfect
space to store all this awesome Crystal you have been harvesting. For some reason..
"""
	},
	{	#7
		'condition':	['population', 10],
		'message':	"""
Your Bots are starting to feel cramped in their crummy little Shacks. You consider designing
more spacious living arrangements, well before you start wondering why your Bots are feeling
anything at all...
"""
	},
	{
		'condition':	['population', 15],
		'message':	"""
[b][color=red]WARNING!! WARNING!![/color][/b] Hostile lifeforms detected in the area! Executing 
contingency program 1x0a4: \n All automated systems in IFF range SET to Militarized_Mode ON! 
"""
	},
]




#	RESET/SAVE/RESTORE
func reset():
	pass
	
func save():
	var saveDict = {
	'current_event':	current_event
	}
	return saveDict

func restore(data):
	current_event = data['current_event']
	for i in range(current_event -1):
		_reward_event(i)

#	INIT
func _ready():
	game = get_node('/root/Game')

#	EVENT CONTROLLERS
func _set_event(E):
	event_object = events[E]

func _reward_event(E):
	var c = "_event_"+str(E)
	if has_method(c):
		call(c)

func _process_event(params):

	if params == null:
		return true
	
	elif params[0] == 'bank':		#require a number of a resource
		var material = params[1]
		var value  = params[2]
		if game.bank.can_afford(material,value):
			return true
	
	elif params[0] == 'skill':		#require a level in resource skill
		var skill = params[1]
		var level = params[2]
		if game.bank.has_skill_level(skill,level):
			return true
	
	elif params[0] == 'population':
		var pop = params[1]
		if game.population.population['current'] >= pop:
			return true
	else:
		print("=====	NO PARAMETER EXISTS FOR CURRENT EVENT CONDITION!!!	=====")
	return false


func check_event():
	if int(event_object.keys()[0]) != current_event:
		_set_event(current_event)
		var passed = _process_event(event_object['condition'])
		if passed:
			game.news.message(event_object['message'],game.game_time)
			_reward_event(current_event)
			if current_event+1 <= events.size()-1:
				current_event += 1
			else:
				game.news.message("[b]End of Story Line[/b]")



#	EVENT ACTUATORS

func _event_0():	#show Metal
	game.bank.get_node('Metal').show()
	game.bank.get_node('skills/Metal').show()
	game.news.message("You are now able to Salvage [b]Metal[/b]!")

func _event_1():	#add scrapyard
	game.construction.show()
	game.construction.make_scrapyard()
	game.construction.get_node('Buildings/cont').set_current_tab(1)


func _event_2():	#show Crystal
	game.bank.get_node('Crystal').show()
	game.bank.get_node('skills/Crystal').show()
	game.news.message("You are now able to Salvage [b]Crystal[/b]!")


func _event_3():	#show Metal workers
	game.population.show()
	game.population.get_node('Metal').show()
	game.news.message("You are now able to assign worker Bots to salvage [b]Metal[/b] for you!")

func _event_4():	#show Cyrstal workers
	game.population.get_node('Crystal').show()
	game.news.message("You are now able to assign worker Bots to salvage [b]Crystal[/b] for you!")

func _event_5():	#add shack
	game.construction.make_shack()
	game.construction.get_node('Buildings/cont').set_current_tab(0)
	game.news.message("Upgrading the [b]Shack[/b] will increase your maximum population!")

func _event_6():	#add crystalcaves
	game.construction.make_crystalcaves()
	game.construction.get_node('Buildings/cont').set_current_tab(1)

func _event_7():	#add garage
	game.construction.make_garage()
	game.construction.get_node('Buildings/cont').set_current_tab(0)

func _event_8():	#show combat map
	game.combat.show()