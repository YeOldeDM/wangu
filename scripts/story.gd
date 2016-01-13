
extends Control

var game
var current_event = 0
var event_object = {-1: null}

var events = [
	{
		'condition':	null,
		'message':	"""
You awake from your cryo-pod and climb out of the impact crater. The landscape 
around you is littered with scrap metal. Maybe you can do something useful with it.
"""
	},
	{
		'condition':	['bank', 0, 15],	#bank 25 metal
		'message':	"""
A large building is discovered! It appears to be an old automated scrapyard.
You should be able to use this to increase the amount of Metal you can store.
"""
	},
	{
		'condition':	['skill',0,1],
		'message':	"""
You've gotten pretty good at gathering metal! How 'bout you try harvesting some 
of the large crystal structures you see growing out of the dirt. The Crystal here
seems to show interesting energy-conduction properties.
"""
	},
	{
		'condition':	['bank',1,50],
		'message':	"""
What is this?! You come across an abandoned Bot auto-factory. If you can build a
couple of these guys, they could help you gather resources.
"""
	},
	{
		'condition':	['population', 3],
		'message':	"""
The Bots seem to be capable of self-replication! Now you know how robot babies are
made. You learn something new everyday!
"""
	},
]

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


func _ready():
	game = get_node('/root/Game')

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
	return false

func check_event():
	if int(event_object.keys()[0]) != current_event:
		_set_event(current_event)
		var passed = _process_event(event_object['condition'])
		if passed:
			game.news.message(event_object['message'],true)
			_reward_event(current_event)
			if current_event+1 <= events.size():
				current_event += 1
			else:
				game.news.message("[b]End of Story Line[/b]")
		
func _event_0():
	game.bank.get_node('Metal').show()
	game.bank.get_node('skills/Metal').show()

func _event_1():
	game.construction.show()


func _event_2():
	game.bank.get_node('Crystal').show()
	game.bank.get_node('skills/Crystal').show()


func _event_3():
	game.population.show()
	game.population.get_node('Metal').show()

func _event_4():
	game.population.get_node('Crystal').show()